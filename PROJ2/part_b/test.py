import matplotlib.pyplot as plt
import numpy as np
import os

tests = ["ping_pong_equal_async", "ping_pong_unequal_async",
         "super_light_async", "super_super_light_async", "recursive_fibonacci_async",
         "math_operations_in_tight_for_loop_async", "math_operations_in_tight_for_loop_fewer_tasks_async",
          "math_operations_in_tight_for_loop_fan_in_async", "math_operations_in_tight_for_loop_reduction_tree_async", 
          "mandelbrot_chunked_async", "spin_between_run_calls_async", "strict_diamond_deps_async",
          "strict_graph_deps_small_async", "strict_graph_deps_med_async", "strict_graph_deps_large_async"]

myonelockres = []
mymultilockres = []
standardres = []
rate = []

def find_last_time(output: str):
  start = output.index("[Parallel + Thread Pool + Sleep]:") + len("[Parallel + Thread Pool + Sleep]:")
  start = output.index('[', start, -1) + 1
  end = output.index(']', start, -1)
  return float(output[start:end])

def find_first_time(output: str):
  start = output.index("[Serial]:") + len("[Serial]:") 
  start = output.index('[', start) + 1
  end = output.index(']', start)
  return float(output[start:end])

# for test in tests:
#   cmd = "./runtasks -n 8 "+test 
#   print(cmd)
#   output = os.popen(cmd).read()
#   myonelockres.append(find_first_time(output))
#   mymultilockres.append(find_last_time(output))
#   cmd = "./runtasks_ref_linux -n 8 "+test 
#   output = os.popen(cmd).read()
#   standardres.append(find_last_time(output))
# print(myonelockres, "\n", mymultilockres, "\n", standardres)

myonelockres_1 = [356.402, 551.445, 78.185, 49.263, 274.047, 420.67, 129.323, 68.295, 68.36, 47.217, 301.809, 3.478, 2.598, 24.626, 182.516]
mymultilockres_1 = [377.939, 512.189, 63.338, 42.504, 272.759, 399.53, 152.664, 68.789, 59.122, 44.515, 303.721, 3.276, 3.332, 21.168, 170.354]
standardres_1 = [285.031, 307.679, 43.604, 21.311, 286.471, 276.436, 114.164, 65.728, 61.773, 44.442, 298.92, 4.158, 3.459, 46.221, 461.809]

myonelockres_2 = [316.13, 389.452, 71.356, 45.453, 278.874, 407.617, 145.129, 67.482, 60.224, 44.624, 299.006, 3.391, 1.823, 29.098, 195.996] 
mymultilockres_2 = [373.614, 417.774, 68.582, 40.936, 265.067, 447.26, 157.817, 62.316, 66.994, 45.986, 315.61, 3.266, 3.329, 32.735, 170.098]
standardres_2 = [304.634, 326.644, 42.353, 25.567, 272.659, 320.177, 125.873, 62.039, 57.427, 46.133, 309.1, 3.562, 3.425, 48.764, 472.062]

myonelockres_3 = [334.869, 439.677, 79.941, 45.028, 271.935, 377.888, 139.749, 68.292, 63.534, 52.79, 309.997, 2.972, 2.439, 31.008, 176.883]
mymultilockres_3 = [385.722, 486.862, 60.282, 48.254, 262.199, 406.946, 153.964, 58.433, 59.616, 45.149, 317.41, 2.639, 2.437, 24.249, 178.919]
standardres_3 = [241.7, 340.985, 42.619, 19.105, 276.736, 268.816, 110.597, 69.102, 60.953, 46.248, 301.105, 3.237, 3.402, 45.774, 335.422]

myonelockres_4 = [320.384, 476.45, 77.685, 44.824, 269.936, 433.389, 141.863, 68.717, 64.171, 46.155, 311.468, 3.141, 1.391, 31.873, 181.893]
mymultilockres_4 = [362.854, 435.561, 62.106, 50.929, 280.061, 421.222, 160.469, 61.799, 58.566, 46.034, 313.646, 2.828, 3.401, 27.905, 168.934] 
standardres_4 = [289.219, 346.98, 44.77, 22.464, 292.874, 269.728, 115.456, 65.023, 63.611, 48.308, 330.338, 3.118, 4.0, 41.135, 466.622]

myonelockres_5 = [329.622, 475.293, 80.558, 48.51, 270.873, 386.973, 145.162, 73.041, 63.859, 47.185, 302.338, 3.692, 2.47, 27.399, 180.094]
mymultilockres_5 = [385.613, 504.416, 60.838, 48.169, 268.084, 390.315, 149.598, 67.558, 62.777, 44.535, 315.505, 2.827, 3.518, 28.423, 164.277]
standardres_5 = [275.863, 340.927, 39.204, 19.322, 284.676, 267.832, 118.309, 63.447, 60.513, 45.109, 298.777, 3.577, 4.559, 48.453, 466.751]

myonelockres = [min(myonelockres_1[i], myonelockres_2[i], myonelockres_3[i], myonelockres_4[i], myonelockres_5[i]) 
                for i in range(len(tests))]
mymultilockres = [min(mymultilockres_1[i], mymultilockres_2[i], mymultilockres_3[i], mymultilockres_4[i], mymultilockres_5[i]) 
                for i in range(len(tests))]
standardres = [min(standardres_1[i], standardres_2[i], standardres_3[i], standardres_4[i], standardres_5[i]) 
                for i in range(len(tests))]

myonelockres = np.array(myonelockres)
mymultilockres = np.array(mymultilockres)
standardres = np.array(standardres)

rate1 = [standardres[i] / myonelockres[i] for i in range(len(tests))]
rate2 = [standardres[i] / mymultilockres[i] for i in range(len(tests))]
rate3 = [myonelockres[i] / mymultilockres[i] for i in range(len(tests))]

x = np.arange(len(tests))
total_width, n = 0.8, 3
width = total_width / n
total_width, n = 0.8, 3
width = total_width / n
x = x - (total_width - width) / 2

fig, ax = plt.subplots(figsize=(20, 16))
# ax.plot(tests, [1 for i in range(len(tests))], 'r')
# ax.plot(tests, rate1, label = "One-lock vs. Standard")
# ax.plot(tests, rate2, label = "Multi-lock vs. Standard")
# ax.plot(tests, rate3, label = "Multi-lock vs. One-lock")
plt.bar(x - width, myonelockres, width=width, label="One-lock")
plt.bar(x , mymultilockres, width=width, label="Multi-lock")
plt.bar(x + width, standardres, width=width, label="Standard")
ax.legend()
ax.set_xticks(x)
ax.set_xticklabels(tests, rotation=30, fontsize="small")
ax.set_ylabel("Mine/Standard")
ax.set_title("Performance comparison.")
fig.savefig("performance.png")
