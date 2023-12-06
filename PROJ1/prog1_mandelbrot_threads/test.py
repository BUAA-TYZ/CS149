import matplotlib.pyplot as plt
import os

os.popen("make mandelbrot")
thread_num = [i for i in range(2, 17)]
speedup_res = []
for i in thread_num:
  command = "./mandelbrot -t " + str(i)
  myoutput = os.popen(command).read()
  rate_begin = myoutput.index('(')
  rate = float(myoutput[rate_begin+1:rate_begin+5])
  speedup_res.append(rate)
fig = plt.figure()
plt.xlabel("# Thread")
plt.ylabel("Speedup x")
plt.plot(thread_num, speedup_res)
plt.savefig("rate.png")
plt.show()