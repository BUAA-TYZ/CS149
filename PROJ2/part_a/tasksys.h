#ifndef _TASKSYS_H
#define _TASKSYS_H

#include "itasksys.h"

#include <cassert>
#include <condition_variable>
#include <exception>
#include <mutex>
#include <queue>
#include <thread>

/*
 * TaskSystemSerial: This class is the student's implementation of a
 * serial task execution engine.  See definition of ITaskSystem in
 * itasksys.h for documentation of the ITaskSystem interface.
 */
class TaskSystemSerial: public ITaskSystem {
    public:
        TaskSystemSerial(int num_threads);
        ~TaskSystemSerial();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
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
        int num_threads_ = 1;
    public:
        TaskSystemParallelSpawn(int num_threads);
        ~TaskSystemParallelSpawn();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
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
        std::mutex task_queue_mtx_;

        std::mutex task_finish_mtx_;
        std::condition_variable task_finish_cv_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task ID and num_total_tasks.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        int finish_task_ = 0;
        int finish_thread_ = 0;

        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemParallelThreadPoolSpinning(int num_threads);
        ~TaskSystemParallelThreadPoolSpinning();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};

/*
 * TaskSystemParallelThreadPoolSleeping: This class is the student's
 * optimized implementation of a parallel task execution engine that uses
 * a thread pool. See definition of ITaskSystem in
 * itasksys.h for documentation of the ITaskSystem interface.
 */
class TaskSystemParallelThreadPoolSleeping: public ITaskSystem {
    private:
        std::condition_variable task_queue_cv_;
        std::mutex task_queue_mtx_;

        std::mutex task_finish_mtx_;
        std::condition_variable task_finish_cv_;

        std::mutex task_exit_mtx_;
        std::condition_variable task_exit_cv_;

        // Store the task source, the task ID and num_total_tasks.
        std::queue<std::pair<IRunnable *, std::pair<int, int>>> task_queue_;
        std::vector<std::thread> threads_;

        int finish_task_ = 0;
        int finish_thread_ = 0;

        int num_threads_ = 1;

        bool stop_ = false;

    public:
        TaskSystemParallelThreadPoolSleeping(int num_threads);
        ~TaskSystemParallelThreadPoolSleeping();
        const char* name();
        void run(IRunnable* runnable, int num_total_tasks);
        TaskID runAsyncWithDeps(IRunnable* runnable, int num_total_tasks,
                                const std::vector<TaskID>& deps);
        void sync();
};

#endif
