#include "tasksys.h"


IRunnable::~IRunnable() {}

ITaskSystem::ITaskSystem(int num_threads) {}
ITaskSystem::~ITaskSystem() {}

/*
 * ================================================================
 * Serial task system implementation
 * ================================================================
 */

const char* TaskSystemSerial::name() {
    return "Serial";
}

TaskSystemSerial::TaskSystemSerial(int num_threads): ITaskSystem(num_threads) {
}

TaskSystemSerial::~TaskSystemSerial() {}

void TaskSystemSerial::run(IRunnable* runnable, int num_total_tasks) {
    for (int i = 0; i < num_total_tasks; i++) {
        runnable->runTask(i, num_total_tasks);
    }
}

TaskID TaskSystemSerial::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                          const std::vector<TaskID>& deps) {
    // You do not need to implement this method.
    return 0;
}

void TaskSystemSerial::sync() {
    // You do not need to implement this method.
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
}

TaskSystemParallelSpawn::~TaskSystemParallelSpawn() {
}

void TaskSystemParallelSpawn::run(IRunnable* runnable, int num_total_tasks) {
    std::vector<std::thread> threads;
    for (int i=0; i<num_threads_; i++) {
        threads.emplace_back([&, i] {
            for (int j=i; j<num_total_tasks; j+=num_threads_)
                runnable->runTask(j, num_total_tasks);
        });
    }
    for (int i=0; i<num_threads_; i++)
        threads[i].join();
}

TaskID TaskSystemParallelSpawn::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                 const std::vector<TaskID>& deps) {
    // You do not need to implement this method.
    return 0;
}

void TaskSystemParallelSpawn::sync() {
    // You do not need to implement this method.
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
            while (!stop_) {
                task_queue_mtx_.lock();
                if (task_queue_.empty()) {
                    task_queue_mtx_.unlock();
                    continue;
                }
                auto task = task_queue_.front();
                task_queue_.pop();
                task_queue_mtx_.unlock();
                // printf("%x %d %d\n", task.first, task.second.first, task.second.second);
                task.first->runTask(task.second.first, task.second.second);

                task_finish_mtx_.lock();
                if (++finish_task_ == task.second.second) {
                    // printf("Task All Done, notify the Run thread.\n");
                    task_finish_mtx_.unlock();
                    task_finish_cv_.notify_one();
                } else {
                    task_finish_mtx_.unlock();
                }
            }

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
    stop_ = true;
    std::unique_lock<std::mutex> guard{task_exit_mtx_};
    task_exit_cv_.wait(guard, [this] {return finish_thread_ == num_threads_; });
}

void TaskSystemParallelThreadPoolSpinning::run(IRunnable* runnable, int num_total_tasks) {
    {
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, num_total_tasks}};
        // assert(task_queue_.empty());
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }

    {
        std::unique_lock<std::mutex> guard{task_finish_mtx_};
        task_finish_cv_.wait(guard, [this, num_total_tasks] {
            // printf("Have Done %d\n", finish_task_);
            return finish_task_ == num_total_tasks;
        });
        finish_task_ = 0;
    }
}

TaskID TaskSystemParallelThreadPoolSpinning::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                              const std::vector<TaskID>& deps) {
    // You do not need to implement this method.
    return 0;
}

void TaskSystemParallelThreadPoolSpinning::sync() {
    // You do not need to implement this method.
    return;
}

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
            while (true) {
                task_queue_cv_.wait(guard);

                if (stop_) {
                    break;
                }

                while (!task_queue_.empty()) {
                    auto task = task_queue_.front();
                    task_queue_.pop();
                    guard.unlock();
                    // printf("%x %d %d\n", task.first, task.second.first, task.second.second);
                    task.first->runTask(task.second.first, task.second.second);

                    task_finish_mtx_.lock();
                    if (++finish_task_ == task.second.second) {
                        // printf("Task All Done, notify the Run thread.\n");
                        task_finish_mtx_.unlock();
                        task_finish_cv_.notify_one();
                    } else {
                        task_finish_mtx_.unlock();
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
    {
        std::lock_guard<std::mutex> guard{task_queue_mtx_};
        std::pair<IRunnable *, std::pair<int, int>> task_item = {runnable, {0, num_total_tasks}};
        // assert(task_queue_.empty());
        for (int i = 0; i < num_total_tasks; i++) {
            task_item.second.first = i;
            task_queue_.push(task_item);
        }
    }
    task_queue_cv_.notify_all();

    {
        std::unique_lock<std::mutex> guard{task_finish_mtx_};
        task_finish_cv_.wait(guard, [this, num_total_tasks] {
            // printf("Have Done %d\n", finish_task_);
            return finish_task_ == num_total_tasks;
        });
        finish_task_ = 0;
    }
}

TaskID TaskSystemParallelThreadPoolSleeping::runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                                    const std::vector<TaskID>& deps) {


    //
    // TODO: CS149 students will implement this method in Part B.
    //

    return 0;
}

void TaskSystemParallelThreadPoolSleeping::sync() {

    //
    // TODO: CS149 students will modify the implementation of this method in Part B.
    //

    return;
}
