|VECTOR_WIDTH|Vector Utilization|
|:---:|:---:|
|2|85.4%|
|4|80.5%|
|8|78%|
|16|76.8%|
- 为什么会下降？
  - 掩码为 1 则 vector utilization lane + 1
  - 我们对 `while (count != 0)` 的转化要求我们必须等待一个 vector 内的全部 count 都为0. 而此时很可能别的元素都在等待而并没有用上，这造就了越来越低的 vector utilization