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