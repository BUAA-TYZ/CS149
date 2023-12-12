import os

tests = ["ping_pong_equal_async", "ping_pong_unequal_async",
         "super_light_async", "super_super_light_async", "recursive_fibonacci_async",
         "math_operations_in_tight_for_loop_async", "math_operations_in_tight_for_loop_fewer_tasks_async",
          "math_operations_in_tight_for_loop_fan_in_async", "math_operations_in_tight_for_loop_reduction_tree_async", 
          "mandelbrot_chunked_async", "spin_between_run_calls_async", "strict_diamond_deps_async",
          "strict_graph_deps_small_async", "strict_graph_deps_med_async", "strict_graph_deps_large_async"]

myres = [0.184, 391.327, 551.966, 71.687, 41.807, 275.800]

for test in tests:
  cmd = "./runtasks -n 8 "+test 
  print(cmd)
  output = os.popen(cmd).read()
  print(output)