Summary
---
- 虚拟机共8个核, 实验的结果也就基于此
- 在这个实验中,我们可以看到性能并不是随着核数的增加而线性增加的.
- 在性能图中, 不难发现性能上升或下降的趋势.
- 有两种思路处理本问题, 一种是分块, 另一种是交错着处理

```cpp
/*********************/
/****  VERSION 1  ****/
/*********************/

for (int i=args->threadId; i<args->height; i+=args->numThreads) {
  int start_row = i;
  mandelbrotSerial(args->x0, args->y0, args->x1, args->y1,
  args->width, args->height, start_row, 1, args->maxIterations, args->output);
}

/*********************/
/****  VERSION 2  ****/
/*********************/

int num_row = args->height / args->numThreads;
int start_row = args->height / args->numThreads * args->threadId;
// If tasks are unbalanced, the last thread must be responsible for more lines of task.
if (args->height%args->numThreads!=0 && args->threadId==args->numThreads-1) {
  num_row = args->height - start_row;
}
mandelbrotSerial(args->x0, args->y0, args->x1, args->y1,
args->width, args->height, start_row, num_row, args->maxIterations, args->output);

```
- VERSION2 性能拉跨, 在8个thread的时候只能加速3.6x
- VERSION1 相比之下能加速 6.4x