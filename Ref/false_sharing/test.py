import os
import matplotlib.pyplot as plt

test_data = [1e4, 1e5, 1e6, 1e7, 1e8]

os.popen("g++ -std=c++17 false_sharing.cpp -o false_sharing -lpthread")

res = []

for i in test_data:
  output = os.popen("./false_sharing "+str(i)).read()
  second_line = output.index("Test2")
  first_end = second_line - 3
  first_begin = output.index("took", 0, second_line) + 5
  second_begin = output.index("took", second_line, -1) + 5
  res.append(float(output[first_begin:first_end])/float(output[second_begin:-3]))

axs = plt.axes()
axs.set_xscale('log')
axs.set_xlabel("data_size")
axs.set_ylabel("Speedup")
plt.plot(test_data, res)
plt.title("False sharing speedup mesurement")
plt.savefig("./rate.png")
