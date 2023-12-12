Summary
---

#### Part_a

1. Complete the Class `TaskSystemParallelSpawn`
   - My initial idea is to construct a thread pool. 
   - When there is a task, put it into a queue.
   - And assign the task dynamically because we know nothing about tasks, so they aren't predictable.
   - Use the conditional variable to notify the threads when tasks come.
```cpp
// CORRECT VERSION
{
    std::unique_lock<std::mutex> guard{task_queue_mtx};
    // VERSION 1
    task_finish_cv.wait(guard, [this, num_total_tasks] {
        return finish == num_total_tasks;
    });
    // VERSION 2
    while (finish != num_total_tasks) {
        task_finish_cv.wait(guard);
    }
}

// WRONG VERSION
while (true) {
    std::unique_lock<std::mutex> guard{task_queue_mtx};
    task_finish_cv.wait(guard);
    if (finish == num_total_tasks) {
        break;
    }
}
```
- In VERSION 1, the condition will be checked first. So it  is equivalent to the VERSION 2.
- It is important that we acquire the lock before check the predicate.
- In Wrong VERSION, the error is extremely implicit, which will cause the deadlock. It will ignore the notification when it acquires the lock.
Even though you notify it without the lock, the lock maybe acquired by someone else. When using the CORRECT VERSION, it holds the lock. So it will ignore any notification.
- It needs much **experience** and patience when doing something parallel.
- It takes the time, but it's worth it.
- Generally, the program will get a speedup from 4x. to 8x.

2. I misunderstand the requirements of the question, so i have done the last quesion. In fact, the Class `TaskSystemParallelSpawn` needes not to create a thread pool. It's in the class `TaskSystemParallelThreadPoolSleeping`...

3. Use an extra lock: `task_finish_mtx_` to reduce the contention, which gets a few ms level speedup.

4. When the destructor finishes, it should wait until all threads finish. Because the destructor will destory the locks, which may be still in use by some detached threads. Add a `task_exit_cv_`

- Result
  - 
```shell
================================================================================
Running task system grading harness... (11 total tests)
  - Detected CPU with 8 execution contexts
  - Task system configured to use at most 8 threads
================================================================================
================================================================================
Executing test: super_super_light...
Reference binary: ./runtasks_ref_linux
Results for: super_super_light
                                        STUDENT   REFERENCE   PERF?
[Serial]                                6.398     9.276       0.69  (OK)
[Parallel + Always Spawn]               120.17    166.169     0.72  (OK)
[Parallel + Thread Pool + Spin]         25.849    23.015      1.12  (OK)
[Parallel + Thread Pool + Sleep]        49.081    50.546      0.97  (OK)
================================================================================
Executing test: super_light...
Reference binary: ./runtasks_ref_linux
Results for: super_light
                                        STUDENT   REFERENCE   PERF?
[Serial]                                50.653    67.443      0.75  (OK)
[Parallel + Always Spawn]               139.395   204.129     0.68  (OK)
[Parallel + Thread Pool + Spin]         39.156    36.191      1.08  (OK)
[Parallel + Thread Pool + Sleep]        51.125    54.263      0.94  (OK)
================================================================================
Executing test: ping_pong_equal...
Reference binary: ./runtasks_ref_linux
Results for: ping_pong_equal
                                        STUDENT   REFERENCE   PERF?
[Serial]                                850.485   1079.225    0.79  (OK)
[Parallel + Always Spawn]               371.079   412.218     0.90  (OK)
[Parallel + Thread Pool + Spin]         222.03    286.352     0.78  (OK)
[Parallel + Thread Pool + Sleep]        244.007   293.229     0.83  (OK)
================================================================================
Executing test: ping_pong_unequal...
Reference binary: ./runtasks_ref_linux
Results for: ping_pong_unequal
                                        STUDENT   REFERENCE   PERF?
[Serial]                                1482.362  1493.649    0.99  (OK)
[Parallel + Always Spawn]               490.87    687.332     0.71  (OK)
[Parallel + Thread Pool + Spin]         308.868   352.929     0.88  (OK)
[Parallel + Thread Pool + Sleep]        350.278   354.223     0.99  (OK)
================================================================================
Executing test: recursive_fibonacci...
Reference binary: ./runtasks_ref_linux
Results for: recursive_fibonacci
                                        STUDENT   REFERENCE   PERF?
[Serial]                                1445.609  1655.9      0.87  (OK)
[Parallel + Always Spawn]               259.279   291.516     0.89  (OK)
[Parallel + Thread Pool + Spin]         238.628   321.418     0.74  (OK)
[Parallel + Thread Pool + Sleep]        250.064   288.727     0.87  (OK)
================================================================================
Executing test: math_operations_in_tight_for_loop...
Reference binary: ./runtasks_ref_linux
Results for: math_operations_in_tight_for_loop
                                        STUDENT   REFERENCE   PERF?
[Serial]                                539.723   548.923     0.98  (OK)
[Parallel + Always Spawn]               797.696   972.079     0.82  (OK)
[Parallel + Thread Pool + Spin]         210.378   221.51      0.95  (OK)
[Parallel + Thread Pool + Sleep]        362.607   336.264     1.08  (OK)
================================================================================
Executing test: math_operations_in_tight_for_loop_fewer_tasks...
Reference binary: ./runtasks_ref_linux
Results for: math_operations_in_tight_for_loop_fewer_tasks
                                        STUDENT   REFERENCE   PERF?
[Serial]                                542.949   537.846     1.01  (OK)
[Parallel + Always Spawn]               776.792   919.421     0.84  (OK)
[Parallel + Thread Pool + Spin]         231.162   241.801     0.96  (OK)
[Parallel + Thread Pool + Sleep]        347.495   340.303     1.02  (OK)
================================================================================
Executing test: math_operations_in_tight_for_loop_fan_in...
Reference binary: ./runtasks_ref_linux
Results for: math_operations_in_tight_for_loop_fan_in
                                        STUDENT   REFERENCE   PERF?
[Serial]                                279.894   279.519     1.00  (OK)
[Parallel + Always Spawn]               155.535   150.266     1.04  (OK)
[Parallel + Thread Pool + Spin]         76.691    86.524      0.89  (OK)
[Parallel + Thread Pool + Sleep]        91.93     96.717      0.95  (OK)
================================================================================
Executing test: math_operations_in_tight_for_loop_reduction_tree...
Reference binary: ./runtasks_ref_linux
Results for: math_operations_in_tight_for_loop_reduction_tree
                                        STUDENT   REFERENCE   PERF?
[Serial]                                277.997   291.413     0.95  (OK)
[Parallel + Always Spawn]               103.008   92.177      1.12  (OK)
[Parallel + Thread Pool + Spin]         64.23     74.493      0.86  (OK)
[Parallel + Thread Pool + Sleep]        71.578    75.417      0.95  (OK)
================================================================================
Executing test: spin_between_run_calls...
Reference binary: ./runtasks_ref_linux
Results for: spin_between_run_calls
                                        STUDENT   REFERENCE   PERF?
[Serial]                                496.803   580.594     0.86  (OK)
[Parallel + Always Spawn]               258.268   314.246     0.82  (OK)
[Parallel + Thread Pool + Spin]         287.65    356.316     0.81  (OK)
[Parallel + Thread Pool + Sleep]        254.99    299.195     0.85  (OK)
================================================================================
Executing test: mandelbrot_chunked...
Reference binary: ./runtasks_ref_linux
Results for: mandelbrot_chunked
                                        STUDENT   REFERENCE   PERF?
[Serial]                                306.123   310.294     0.99  (OK)
[Parallel + Always Spawn]               45.216    45.864      0.99  (OK)
[Parallel + Thread Pool + Spin]         43.471    49.78       0.87  (OK)
[Parallel + Thread Pool + Sleep]        43.443    45.499      0.95  (OK)
================================================================================
Overall performance results
[Serial]                                : All passed Perf
[Parallel + Always Spawn]               : All passed Perf
[Parallel + Thread Pool + Spin]         : All passed Perf
[Parallel + Thread Pool + Sleep]        : All passed Perf
```