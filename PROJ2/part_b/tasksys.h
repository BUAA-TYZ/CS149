#ifndef _TASKSYS_H
#define _TASKSYS_H

#include "itasksys.h"

#include <cassert>
#include <condition_variable>
#include <exception>
#include <mutex>
#include <queue>
#include <thread>
#include <unordered_map>

/*
 * TaskSystemParallelThreadPoolSleeping: This class is the student's
 * optimized implementation of a parallel task execution engine that uses
 * a thread pool. See definition of ITaskSystem in
 * itasksys.h for documentation of the ITaskSystem interface.
 */
class TaskSystemParallelThreadPoolSleeping: public ITaskSystem {
    private:
        class TaskInfo {
        public:
            std::condition_variable* task_finish_cv_;
            std::mutex* task_mtx_;

            int num_finish_tasks_ = 0;
            int num_total_tasks_;

            int task_id_;
            TaskInfo(int t, int n): task_id_(t), num_total_tasks_(n) {
                task_finish_cv_ = new std::condition_variable();
                task_mtx_ = new std::mutex();
            }

            ~TaskInfo() {
                delete task_finish_cv_;
                delete task_mtx_;
            }
        };

        std::condition_variable task_queue_cv_;
        std::mutex task_queue_mtx_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task index and TaskID.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        // Use the task_state_mtx_ to ensure the multi-thread security.
        std::mutex task_state_mtx_;
        std::vector<std::shared_ptr<TaskInfo>> task_state_;
        TaskID task_id_ = 0;

        std::condition_variable task_sync_cv_;

        int finish_thread_ = 0;
        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemParallelThreadPoolSleeping(int num_threads);
        ~TaskSystemParallelThreadPoolSleeping();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        void launchTask(int task_id, IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};

/********************************************************************
 ******************      Ignore all below.         ******************
 ********************************************************************/

/*
 * TaskSystemSerial: This class is the student's implementation of a
 * serial task execution engine.  See definition of ITaskSystem in
 * itasksys.h for documentation of the ITaskSystem interface.
 */
class TaskSystemSerial: public ITaskSystem {
    private:
        std::condition_variable task_queue_cv_;
        std::mutex task_queue_mtx_;

        // Managed by task_state_mtx_
        std::unordered_map<TaskID, std::condition_variable> task_finish_cv_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task index and TaskID.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        // Store the finished tasks of the TaskID and num_total_tasks of the TaskID
        // Use the task_state_mtx_ to ensure the multi-thread security.
        std::mutex task_state_mtx_;
        std::unordered_map<TaskID, std::pair<int, int>> task_state_;
        TaskID task_id_ = 0;

        std::condition_variable task_sync_cv_;

        int finish_thread_ = 0;
        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemSerial(int num_threads);
        ~TaskSystemSerial();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        void launchTask(int task_id, IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};

/*
 * TaskSystemParallelSpawn: This class is the student's implementation of a
 * parallel task execution engine that spawns threads in every run()
 * call.  See definition of ITaskSystem in itasksys.h for documentation
 * of the ITaskSystem interface.
 */
class TaskSystemParallelSpawn: public ITaskSystem {
    private:
        std::condition_variable task_queue_cv_;
        std::mutex task_queue_mtx_;

        // Managed by task_state_mtx_
        std::unordered_map<TaskID, std::condition_variable> task_finish_cv_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task index and TaskID.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        // Store the finished tasks of the TaskID and num_total_tasks of the TaskID
        // Use the task_state_mtx_ to ensure the multi-thread security.
        std::mutex task_state_mtx_;
        std::unordered_map<TaskID, std::pair<int, int>> task_state_;
        TaskID task_id_ = 0;

        std::condition_variable task_sync_cv_;

        int finish_thread_ = 0;
        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemParallelSpawn(int num_threads);
        ~TaskSystemParallelSpawn();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        void launchTask(int task_id, IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};

/*
 * TaskSystemParallelThreadPoolSpinning: This class is the student's
 * implementation of a parallel task execution engine that uses a
 * thread pool. See definition of ITaskSystem in itasksys.h for
 * documentation of the ITaskSystem interface.
 */
class TaskSystemParallelThreadPoolSpinning: public ITaskSystem {
    private:
        std::condition_variable task_queue_cv_;
        std::mutex task_queue_mtx_;

        // Managed by task_state_mtx_
        std::unordered_map<TaskID, std::condition_variable> task_finish_cv_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task index and TaskID.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        // Store the finished tasks of the TaskID and num_total_tasks of the TaskID
        // Use the task_state_mtx_ to ensure the multi-thread security.
        std::mutex task_state_mtx_;
        std::unordered_map<TaskID, std::pair<int, int>> task_state_;
        TaskID task_id_ = 0;

        std::condition_variable task_sync_cv_;

        int finish_thread_ = 0;
        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemParallelThreadPoolSpinning(int num_threads);
        ~TaskSystemParallelThreadPoolSpinning();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        void launchTask(int task_id, IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};



#endif
