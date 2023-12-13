import matplotlib.pyplot as plt
import os

tests = ["ping_pong_equal_async", "ping_pong_unequal_async",
         "super_light_async", "super_super_light_async", "recursive_fibonacci_async",
         "math_operations_in_tight_for_loop_async", "math_operations_in_tight_for_loop_fewer_tasks_async",
          "math_operations_in_tight_for_loop_fan_in_async", "math_operations_in_tight_for_loop_reduction_tree_async", 
          "mandelbrot_chunked_async", "spin_between_run_calls_async", "strict_diamond_deps_async",
          "strict_graph_deps_small_async", "strict_graph_deps_med_async", "strict_graph_deps_large_async"]

myres = []
standardres = []
rate = []

def find_time(output: str):
  start = output.index("[Parallel + Thread Pool + Sleep]:") + len("[Parallel + Thread Pool + Sleep]:")
  start = output.index('[', start, -1) + 1
  end = output.index(']', start, -1)
  return float(output[start:end])


# for test in tests:
#   cmd = "./runtasks -n 8 "+test 
#   print(cmd)
#   output = os.popen(cmd).read()
#   myres.append(find_time(output))
#   cmd = "./runtasks_ref_linux -n 8 "+test 
#   output = os.popen(cmd).read()
#   standardres.append(find_time(output))
# print(myres, "\n", standardres)

myres = [349.043, 449.44, 73.885, 41.856, 272.917, 379.474, 139.449,
          69.951, 58.108, 46.373, 312.98, 3.246, 2.27, 29.738, 191.187]
standardres = [272.39, 325.931, 39.097, 20.45, 281.822, 266.272, 115.128,
                62.067, 57.134, 44.303, 331.424, 3.614, 4.31, 49.145, 477.254]

rate = [myres[i]/standardres[i] for i in range(len(myres))]

fig, ax = plt.subplots(figsize=(20, 16), layout="constrained")
ax.plot(tests, rate)
ax.plot(tests, [1 for i in range(len(tests))])
ax.set_xticks(tests)
ax.set_xticklabels(tests, rotation=45, fontsize="small")
ax.set_ylabel("Mine/Standard")
ax.set_title("Performance comparison.")
fig.savefig("rate.png")
