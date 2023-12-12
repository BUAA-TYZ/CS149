#include <chrono>
#include <cstdio>
#include <thread>
#include <vector>

#define CACHE_LINE_SIZE 64
#define MAX_THREADS 8

struct padded_t {
  int val;
  char padding[CACHE_LINE_SIZE - sizeof(int)];
};

class Work {
  private:
    int num_iterations;
  public:
    Work(int n): num_iterations(n) {}
    void operator()(int* arg) {
      for (long long i=0; i<num_iterations; i++)
        (*arg)++;
    }
};

void test1(int num_threads, int num_iterations) {
  int counter[MAX_THREADS];
  std::vector<std::thread> threads;
  for (int i=0; i<num_threads; i++)
    threads.emplace_back(Work(num_iterations), &counter[i]);
  for (int i=0; i<num_threads; i++)
    threads[i].join();
}

void test2(int num_threads, int num_iterations) {
  padded_t counter[MAX_THREADS];
  std::vector<std::thread> threads;
  for (int i=0; i<num_threads; i++)
    threads.emplace_back(Work(num_iterations), &counter[i].val);
  for (int i=0; i<num_threads; i++)
    threads[i].join();
}

int main(int argc, char** argv) {
  if (argc != 2) {
    exit(1);
  }
  int num_iterations = atoi(argv[1]);

  auto start = std::chrono::high_resolution_clock::now();
  test1(MAX_THREADS, num_iterations);
  auto stop = std::chrono::high_resolution_clock::now();
  printf("Test1 took %.2f ms\n", std::chrono::duration<double, std::ratio<1,1000>>(stop - start).count());

  start = std::chrono::high_resolution_clock::now();
  test2(MAX_THREADS, num_iterations);
  stop = std::chrono::high_resolution_clock::now();
  printf("Test2 took %.2f ms\n", std::chrono::duration<double, std::ratio<1,1000>>(stop - start).count());

}