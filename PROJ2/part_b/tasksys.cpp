#include "tasksys.h"


IRunnable::~IRunnable() {}

ITaskSystem::ITaskSystem(int num_threads) {}
ITaskSystem::~ITaskSystem() {}

/*
 * ================================================================
 * Parallel Thread Pool Sleeping Task System Implementation
 * ================================================================
 */

const char* TaskSystemParallelThreadPoolSleeping::name() {
    return "Parallel + Thread Pool + Sleep";
}

TaskSystemParallelThreadPoolSleeping::TaskSystemParallelThreadPoolSleeping(int num_threads): ITaskSystem(num_threads) {
    num_threads_ = num_threads;

    for (int i=0; i<num_threads_; i++) {
        threads_.emplace_back([i, this]() {
            std::unique_lock<std::mutex> guard{task_queue_mtx_};
            while (!stop_) {
                task_queue_cv_.wait(guard);

                if (stop_) {
                    break;
                }

                while (!task_queue_.empty()) {
                    auto task = task_queue_.front();
                    task_queue_.pop();
                    guard.unlock();
                    // printf("TaskID: %d, TaskIndex: %d\n", task.second.second, task.second.first);
                    int task_id = task.second.second;
                    task_state_mtx_.lock();
                    if (task_state_.count(task_id) == 0) {
                       throw std::runtime_error("Depend on tasks not created."); 
                    }
                    int num_total_tasks = task_state_[task_id].second;
                    task_state_mtx_.unlock();

                    task.first->runTask(task.second.first, num_total_tasks);

                    task_state_mtx_.lock();
                    if (++task_state_[task_id].first == num_total_tasks) {
                        printf("TaskID: %d All Done, notify the thread.\n", task_id);
                        task_state_mtx_.unlock();
                        task_finish_cv_[task_id].notify_all();
                        task_sync_cv_.notify_all();
                    } else {
                        task_state_mtx_.unlock();
                    }

                    guard.lock();
                }
            }
            guard.unlock();

            {
                std::lock_guard<std::mutex> guard{task_exit_mtx_};
                if (++finish_thread_ == num_threads_)
                    task_exit_cv_.notify_one();
            }
        });
    }

    for (int i=0; i<num_threads_; i++) {
        threads_[i].detach();
    }
}

TaskSystemParallelThreadPoolSleeping::~TaskSystemParallelThreadPoolSleeping() {
    {
        // Lock is needed to wait until the thread finishes working.
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        stop_ = true;
    }
    task_queue_cv_.notify_all();

    {
        std::unique_lock<std::mutex> guard{task_exit_mtx_};
        task_exit_cv_.wait(guard, [this] {return finish_thread_ == num_threads_; }); 
    }
}

void TaskSystemParallelThreadPoolSleeping::run(IRunnable* runnable, int num_total_tasks) {
    runAsyncWithDeps(runnable, num_total_tasks, {});
    sync();
}

void TaskSystemParallelThreadPoolSleeping::launchTask(int task_id, IRunnable* runnable, int num_total_tasks) {
    {
        printf("Launch the task %d\n", task_id);
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, task_id}};
        // assert(task_queue_.empty());
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }
    task_queue_cv_.notify_all(); 
}

TaskID TaskSystemParallelThreadPoolSleeping::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                    const std::vector<TaskID>& deps) {

    int task_id = task_id_++;

    printf("Launch the task %d depended on {", task_id);
    for (auto id: deps)  printf("%d ", id);
    printf("}\n");

    {
        std::lock_guard<std::mutex> guard{task_state_mtx_};
        task_state_[task_id] = {0, num_total_tasks};
    }

    std::vector<TaskID> not_finished_task{};
    task_state_mtx_.lock();
    for (auto id: deps) {
        if (task_state_.count(id)) {
            if (task_state_[id].first != task_state_[id].second) {
                not_finished_task.emplace_back(id);
            }
        } else {
            throw std::runtime_error("Depend on tasks not created.");
        }
    }
    task_state_mtx_.unlock();


    if (not_finished_task.empty()) {
        launchTask(task_id, runnable, num_total_tasks);
    } else {
        std::thread t1{[=] {
            // std::vector<std::thread> threads;
            // for (size_t i=0; i<not_finished_task.size(); i++) {
            //     int task_id = not_finished_task[i];
            //     threads.emplace_back([this, i, task_id] {
            //         std::unique_lock<std::mutex> guard{task_state_mtx_};
            //         task_finish_cv_[task_id].wait(guard, [this, task_id] {
            //             return task_state_[task_id].first == task_state_[task_id].second;
            //         });
            //     });
            // }

            // for (size_t i=0; i<not_finished_task.size(); i++)
            //     threads[i].join();
            for (size_t i=0; i<not_finished_task.size(); i++) {
                int task_id = not_finished_task[i];
                std::unique_lock<std::mutex> guard{task_state_mtx_};
                task_finish_cv_[task_id].wait(guard, [this, task_id] {
                    return task_state_[task_id].first == task_state_[task_id].second;
                });
            }
            launchTask(task_id, runnable, num_total_tasks);
        }};
        t1.detach();
    }

    return task_id;
}

void TaskSystemParallelThreadPoolSleeping::sync() {
    std::unique_lock<std::mutex> guard{task_state_mtx_};
    task_sync_cv_.wait(guard, [this] {
        bool finished = true;

        for (auto& x: task_state_) {
            if (x.second.first != x.second.second) {
                finished = false;
                break;
            }
        }
        return finished;
    });
    return;
}

/*
 * ================================================================
 * Ignore all below. They are the same as TaskSystemParallelThreadPoolSleeping.
 * I replace them because the tests are too stupid.
 * ================================================================
 */


/*
 * ================================================================
 * Serial task system implementation
 * ================================================================
 */

const char* TaskSystemSerial::name() {
    return "Serial";
}

TaskSystemSerial::TaskSystemSerial(int num_threads): ITaskSystem(num_threads) {
    num_threads_ = num_threads;

    for (int i=0; i<num_threads_; i++) {
        threads_.emplace_back([i, this]() {
            std::unique_lock<std::mutex> guard{task_queue_mtx_};
            while (!stop_) {
                task_queue_cv_.wait(guard);

                if (stop_) {
                    break;
                }

                while (!task_queue_.empty()) {
                    auto task = task_queue_.front();
                    task_queue_.pop();
                    guard.unlock();
                    // printf("TaskID: %d, TaskIndex: %d\n", task.second.second, task.second.first);
                    int task_id = task.second.second;
                    task_state_mtx_.lock();
                    if (task_state_.count(task_id) == 0) {
                       throw std::runtime_error("Depend on tasks not created."); 
                    }
                    int num_total_tasks = task_state_[task_id].second;
                    task_state_mtx_.unlock();

                    task.first->runTask(task.second.first, num_total_tasks);

                    task_state_mtx_.lock();
                    if (++task_state_[task_id].first == num_total_tasks) {
                        // printf("TaskID: %d All Done, notify the thread.\n", task_id);
                        task_state_mtx_.unlock();
                        task_finish_cv_[task_id].notify_all();
                        task_sync_cv_.notify_all();
                    } else {
                        task_state_mtx_.unlock();
                    }

                    guard.lock();
                }
            }
            guard.unlock();

            {
                std::lock_guard<std::mutex> guard{task_exit_mtx_};
                if (++finish_thread_ == num_threads_)
                    task_exit_cv_.notify_one();
            }
        });
    }

    for (int i=0; i<num_threads_; i++) {
        threads_[i].detach();
    }
}

TaskSystemSerial::~TaskSystemSerial() {
    {
        // Lock is needed to wait until the thread finishes working.
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        stop_ = true;
    }
    task_queue_cv_.notify_all();

    {
        std::unique_lock<std::mutex> guard{task_exit_mtx_};
        task_exit_cv_.wait(guard, [this] {return finish_thread_ == num_threads_; }); 
    }
}

void TaskSystemSerial::run(IRunnable* runnable, int num_total_tasks) {
    runAsyncWithDeps(runnable, num_total_tasks, {});
    sync();
}

void TaskSystemSerial::launchTask(int task_id, IRunnable* runnable, int num_total_tasks) {
    {
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, task_id}};
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }
    task_queue_cv_.notify_all(); 
}

TaskID TaskSystemSerial::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                    const std::vector<TaskID>& deps) {
    int task_id = task_id_++;

    // printf("Lauch the task %d depended on {", task_id);
    // for (auto id: deps)  printf("%d ", id);
    // printf("}\n");

    {
        std::lock_guard<std::mutex> guard{task_state_mtx_};
        task_state_[task_id] = {0, num_total_tasks};
    }

    std::vector<TaskID> not_finished_task{};
    task_state_mtx_.lock();
    for (auto id: deps) {
        if (task_state_.count(id)) {
            if (task_state_[id].first != task_state_[id].second) {
                not_finished_task.emplace_back(id);
            }
        } else {
            throw std::runtime_error("Depend on tasks not created.");
        }
    }
    task_state_mtx_.unlock();


    if (not_finished_task.empty()) {
        launchTask(task_id, runnable, num_total_tasks);
    } else {
        std::thread t1{[=] {
            for (size_t i=0; i<not_finished_task.size(); i++) {
                int task_id = not_finished_task[i];
                std::unique_lock<std::mutex> guard{task_state_mtx_};
                task_finish_cv_[task_id].wait(guard, [this, task_id] {
                    return task_state_[task_id].first == task_state_[task_id].second;
                });
            }
            launchTask(task_id, runnable, num_total_tasks);
        }};
        t1.detach();
    }

    return task_id;
}

void TaskSystemSerial::sync() {
    std::unique_lock<std::mutex> guard{task_state_mtx_};
    task_sync_cv_.wait(guard, [this] {
        bool finished = true;

        for (auto& x: task_state_) {
            if (x.second.first != x.second.second) {
                finished = false;
                break;
            }
        }
        return finished;
    });
    return;
}

/*
 * ================================================================
 * Parallel Task System Implementation
 * ================================================================
 */

const char* TaskSystemParallelSpawn::name() {
    return "Parallel + Always Spawn";
}

TaskSystemParallelSpawn::TaskSystemParallelSpawn(int num_threads): ITaskSystem(num_threads) {
    num_threads_ = num_threads;

    for (int i=0; i<num_threads_; i++) {
        threads_.emplace_back([i, this]() {
            std::unique_lock<std::mutex> guard{task_queue_mtx_};
            while (!stop_) {
                task_queue_cv_.wait(guard);

                if (stop_) {
                    break;
                }

                while (!task_queue_.empty()) {
                    auto task = task_queue_.front();
                    task_queue_.pop();
                    guard.unlock();
                    // printf("TaskID: %d, TaskIndex: %d\n", task.second.second, task.second.first);
                    int task_id = task.second.second;
                    task_state_mtx_.lock();
                    if (task_state_.count(task_id) == 0) {
                       throw std::runtime_error("Depend on tasks not created."); 
                    }
                    int num_total_tasks = task_state_[task_id].second;
                    task_state_mtx_.unlock();

                    task.first->runTask(task.second.first, num_total_tasks);

                    task_state_mtx_.lock();
                    if (++task_state_[task_id].first == num_total_tasks) {
                        // printf("TaskID: %d All Done, notify the thread.\n", task_id);
                        task_state_mtx_.unlock();
                        task_finish_cv_[task_id].notify_all();
                        task_sync_cv_.notify_all();
                    } else {
                        task_state_mtx_.unlock();
                    }

                    guard.lock();
                }
            }
            guard.unlock();

            {
                std::lock_guard<std::mutex> guard{task_exit_mtx_};
                if (++finish_thread_ == num_threads_)
                    task_exit_cv_.notify_one();
            }
        });
    }

    for (int i=0; i<num_threads_; i++) {
        threads_[i].detach();
    }
}

TaskSystemParallelSpawn::~TaskSystemParallelSpawn() {
    {
        // Lock is needed to wait until the thread finishes working.
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        stop_ = true;
    }
    task_queue_cv_.notify_all();

    {
        std::unique_lock<std::mutex> guard{task_exit_mtx_};
        task_exit_cv_.wait(guard, [this] {return finish_thread_ == num_threads_; }); 
    }
}

void TaskSystemParallelSpawn::run(IRunnable* runnable, int num_total_tasks) {


    //
    // TODO: CS149 students will modify the implementation of this
    // method in Parts A and B.  The implementation provided below runs all
    // tasks sequentially on the calling thread.
    //

    runAsyncWithDeps(runnable, num_total_tasks, {});
    sync();
}

void TaskSystemParallelSpawn::launchTask(int task_id, IRunnable* runnable, int num_total_tasks) {
    {
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, task_id}};
        // assert(task_queue_.empty());
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }
    task_queue_cv_.notify_all(); 
}

TaskID TaskSystemParallelSpawn::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                    const std::vector<TaskID>& deps) {

    int task_id = task_id_++;

    // printf("Lauch the task %d depended on {", task_id);
    // for (auto id: deps)  printf("%d ", id);
    // printf("}\n");

    {
        std::lock_guard<std::mutex> guard{task_state_mtx_};
        task_state_[task_id] = {0, num_total_tasks};
    }

    std::vector<TaskID> not_finished_task{};
    task_state_mtx_.lock();
    for (auto id: deps) {
        if (task_state_.count(id)) {
            if (task_state_[id].first != task_state_[id].second) {
                not_finished_task.emplace_back(id);
            }
        } else {
            throw std::runtime_error("Depend on tasks not created.");
        }
    }
    task_state_mtx_.unlock();


    if (not_finished_task.empty()) {
        launchTask(task_id, runnable, num_total_tasks);
    } else {
        std::thread t1{[=] {
            for (size_t i=0; i<not_finished_task.size(); i++) {
                int task_id = not_finished_task[i];
                std::unique_lock<std::mutex> guard{task_state_mtx_};
                task_finish_cv_[task_id].wait(guard, [this, task_id] {
                    return task_state_[task_id].first == task_state_[task_id].second;
                });
            }
            task_sync_cv_.notify_all();
            launchTask(task_id, runnable, num_total_tasks);
        }};
        t1.detach();
    }

    return task_id;
}

void TaskSystemParallelSpawn::sync() {
    std::unique_lock<std::mutex> guard{task_state_mtx_};
    task_sync_cv_.wait(guard, [this] {
        bool finished = true;

        for (auto& x: task_state_) {
            if (x.second.first != x.second.second) {
                finished = false;
                break;
            }
        }
        return finished;
    });
    return;
}

/*
 * ================================================================
 * Parallel Thread Pool Spinning Task System Implementation
 * ================================================================
 */

const char* TaskSystemParallelThreadPoolSpinning::name() {
    return "Parallel + Thread Pool + Spin";
}

TaskSystemParallelThreadPoolSpinning::TaskSystemParallelThreadPoolSpinning(int num_threads): ITaskSystem(num_threads) {
    num_threads_ = num_threads;

    for (int i=0; i<num_threads_; i++) {
        threads_.emplace_back([i, this]() {
            std::unique_lock<std::mutex> guard{task_queue_mtx_};
            while (!stop_) {
                task_queue_cv_.wait(guard);

                if (stop_) {
                    break;
                }

                while (!task_queue_.empty()) {
                    auto task = task_queue_.front();
                    task_queue_.pop();
                    guard.unlock();
                    // printf("TaskID: %d, TaskIndex: %d\n", task.second.second, task.second.first);
                    int task_id = task.second.second;
                    task_state_mtx_.lock();
                    if (task_state_.count(task_id) == 0) {
                       throw std::runtime_error("Depend on tasks not created."); 
                    }
                    int num_total_tasks = task_state_[task_id].second;
                    task_state_mtx_.unlock();

                    task.first->runTask(task.second.first, num_total_tasks);

                    task_state_mtx_.lock();
                    if (++task_state_[task_id].first == num_total_tasks) {
                        // printf("TaskID: %d All Done, notify the thread.\n", task_id);
                        task_state_mtx_.unlock();
                        task_finish_cv_[task_id].notify_all();
                        task_sync_cv_.notify_all();
                    } else {
                        task_state_mtx_.unlock();
                    }

                    guard.lock();
                }
            }
            guard.unlock();

            {
                std::lock_guard<std::mutex> guard{task_exit_mtx_};
                if (++finish_thread_ == num_threads_)
                    task_exit_cv_.notify_one();
            }
        });
    }

    for (int i=0; i<num_threads_; i++) {
        threads_[i].detach();
    }
}

TaskSystemParallelThreadPoolSpinning::~TaskSystemParallelThreadPoolSpinning() {
    {
        // Lock is needed to wait until the thread finishes working.
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        stop_ = true;
    }
    task_queue_cv_.notify_all();

    {
        std::unique_lock<std::mutex> guard{task_exit_mtx_};
        task_exit_cv_.wait(guard, [this] {return finish_thread_ == num_threads_; }); 
    }
}

void TaskSystemParallelThreadPoolSpinning::run(IRunnable* runnable, int num_total_tasks) {


    //
    // TODO: CS149 students will modify the implementation of this
    // method in Parts A and B.  The implementation provided below runs all
    // tasks sequentially on the calling thread.
    //

    runAsyncWithDeps(runnable, num_total_tasks, {});
    sync();
}

void TaskSystemParallelThreadPoolSpinning::launchTask(int task_id, IRunnable* runnable, int num_total_tasks) {
    {
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, task_id}};
        // assert(task_queue_.empty());
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }
    task_queue_cv_.notify_all(); 
}

TaskID TaskSystemParallelThreadPoolSpinning::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                    const std::vector<TaskID>& deps) {

    int task_id = task_id_++;

    // printf("Lauch the task %d depended on {", task_id);
    // for (auto id: deps)  printf("%d ", id);
    // printf("}\n");

    {
        std::lock_guard<std::mutex> guard{task_state_mtx_};
        task_state_[task_id] = {0, num_total_tasks};
    }

    std::vector<TaskID> not_finished_task{};
    task_state_mtx_.lock();
    for (auto id: deps) {
        if (task_state_.count(id)) {
            if (task_state_[id].first != task_state_[id].second) {
                not_finished_task.emplace_back(id);
            }
        } else {
            throw std::runtime_error("Depend on tasks not created.");
        }
    }
    task_state_mtx_.unlock();


    if (not_finished_task.empty()) {
        launchTask(task_id, runnable, num_total_tasks);
    } else {
        std::thread t1{[=] {
            // std::vector<std::thread> threads;
            // for (size_t i=0; i<not_finished_task.size(); i++) {
            //     int task_id = not_finished_task[i];
            //     threads.emplace_back([this, i, task_id] {
            //         std::unique_lock<std::mutex> guard{task_state_mtx_};
            //         task_finish_cv_[task_id].wait(guard, [this, task_id] {
            //             return task_state_[task_id].first == task_state_[task_id].second;
            //         });
            //     });
            // }

            // for (size_t i=0; i<not_finished_task.size(); i++)
            //     threads[i].join();
            for (size_t i=0; i<not_finished_task.size(); i++) {
                int task_id = not_finished_task[i];
                std::unique_lock<std::mutex> guard{task_state_mtx_};
                task_finish_cv_[task_id].wait(guard, [this, task_id] {
                    return task_state_[task_id].first == task_state_[task_id].second;
                });
            }
            task_sync_cv_.notify_all();
            launchTask(task_id, runnable, num_total_tasks);
        }};
        t1.detach();
    }

    return task_id;
}

void TaskSystemParallelThreadPoolSpinning::sync() {
    std::unique_lock<std::mutex> guard{task_state_mtx_};
    task_sync_cv_.wait(guard, [this] {
        bool finished = true;

        for (auto& x: task_state_) {
            if (x.second.first != x.second.second) {
                finished = false;
                break;
            }
        }
        return finished;
    });
    return;
}


