# Analysis


I just found something weird.

Firstly there is the notion of gang instance in ISPC that uses the SIMD instruction to improve the performance 
withing the same core.

## For example 
**Using 1 core, scalar instructions**
We can complete the Serial version in **~140ms**

**Using 1 core, SIMD instructions**
We can complete the same operation in **~40ms**
A **~3.5x** speedup in same core, same thread just using the SIMD instruction.

We can also do the same thing in multiple cores what ISPC calls as **Task parallelism**.

> [!NOTE]  
> Though the performance increase in the Task parallalisation is not **Linear**

> *I think* there is some **Overhead** in the task *Management* that is why the performance is not increasing linearly.


## Findings

| Number of Tasks | Speedup Expected | Speedup Gained | Parallel Efficiency |
|-----------------|-------------------|-----------------|---------------------|
| 1               | 3.49              | 3.49            | 100%                |
| 2               | ~7                | 6.62            | 94.57%              |
| 4               | ~14               | 8.62            | 61.57%              |
| 8               | ~28               | 14.38           | 51.36%              |
| 10              | ~35               | 17              | 48.57%              |
| 20              | ~70               | 28.51           | 40.73%              |
| 40              | ~140              | 40              | 28.57%              |
| 80              | ~280              | 43              | 15.36%              |
| 100             | ~350              | 43              | 12.29%              |

### Notes on Parallel Efficiency Calculation:
- Parallel Efficiency = (Speedup Gained / Speedup Expected) * 100
- For the first row (1 task), the efficiency is 100% as the expected and gained speedups are the same.
- Calculations are rounded to two decimal places.



> [!NOTE]  
> The following analysis was done by claude-3.5-sonnet

### Analysis:
1. **Perfect Scaling**: At 1 task, we see perfect scaling with 100% efficiency.
2. **Near-Linear Scaling**: Up to 2 tasks, the efficiency remains very high (94.57%), indicating near-linear scaling.
3. **Diminishing Returns**: Beyond 2 tasks, we observe rapidly diminishing returns. This is likely due to:
   - Overhead in task management
   - Potential resource contention (e.g., memory bandwidth, cache)
   - Load imbalance between tasks
4. **Saturation**: After 40 tasks, the speedup gained plateaus around 43x, suggesting we've reached the limits of parallelization for this problem on the given hardware.

This efficiency metric provides a clearer picture of how well we're utilizing the additional computational resources as we increase the number of tasks. It directly shows the percentage of ideal performance we're achieving, making it easier to identify the point of diminishing returns in our parallelization efforts.

### Detailed Analysis of Efficiency Behavior

The observed efficiency pattern, where performance doesn't scale linearly with the increase in cores/tasks, is a common phenomenon in parallel computing. While it might seem counterintuitive at first, there are several reasons for this behavior:

1. **Amdahl's Law**:
   Amdahl's Law states that the potential speedup of a program using multiple processors is limited by the sequential fraction of the program. In the Mandelbrot set calculation, there might be parts of the code that cannot be parallelized, which limits the overall speedup.

2. **Communication Overhead**:
   As we increase the number of tasks, there's an increase in the communication required between these tasks. This includes task creation, synchronization, and result aggregation. This overhead doesn't exist in the serial version and grows with the number of tasks.

3. **Memory Bandwidth Limitations**:
   Modern CPUs can process data much faster than they can fetch it from memory. As we add more cores/tasks, we may hit the limits of memory bandwidth. All cores share the same memory subsystem, and at some point, adding more cores doesn't help because we can't feed them data fast enough.

4. **Cache Coherence**:
   In multi-core systems, maintaining cache coherence (ensuring all cores have a consistent view of memory) becomes more challenging and costly as the number of cores increases. This can lead to increased cache misses and memory access times.

5. **Load Imbalance**:
   The Mandelbrot set calculation might have varying computational requirements for different parts of the image. Some tasks might finish quickly while others take longer, leading to idle time for some cores while waiting for others to complete.

6. **OS and Hardware Scheduling**:
   The operating system and hardware schedulers play a role in how tasks are distributed across cores. As the number of tasks increases, the complexity of efficient scheduling also increases, potentially leading to suboptimal task distribution.

7. **Power and Thermal Constraints**:
   Modern CPUs often have turbo boost capabilities, allowing them to run at higher clock speeds when only a few cores are active. As more cores are utilized, the CPU may need to reduce clock speeds to stay within power and thermal limits, affecting per-core performance.

8. **NUMA Effects**:
   On systems with Non-Uniform Memory Access (NUMA), accessing memory associated with another NUMA node is slower. As we scale to more cores, we may start seeing these effects, especially if the tasks are not NUMA-aware.

9. **Diminishing Returns of Parallelism**:
   In the Mandelbrot calculation, as we divide the work into smaller and smaller chunks (by increasing the number of tasks), the overhead of managing these tasks starts to outweigh the benefits of parallelism.

10. **Hardware-Specific Limitations**:
    The specific hardware being used (CPU architecture, cache sizes, memory configuration) can introduce its own bottlenecks that become apparent as we scale up the number of tasks.

### Conclusion

The observed efficiency pattern is a result of the complex interplay between software parallelism and hardware capabilities. While parallel processing offers significant performance improvements, it's subject to various limiting factors that prevent linear scaling.

In practice, finding the optimal number of tasks involves balancing the benefits of parallelism against these limiting factors. For this specific Mandelbrot set implementation, it appears that the sweet spot lies somewhere between 10 and 40 tasks, after which the benefits of adding more tasks are minimal or even counterproductive.

To further optimize performance, one might consider:
- Optimizing memory access patterns to better utilize cache and reduce memory bandwidth pressure.
- Implementing dynamic load balancing to address potential workload imbalances.
- Profiling the code to identify and optimize any sequential bottlenecks.
- Experimenting with different task granularities to find the optimal balance between parallelism and overhead.

Understanding these factors not only explains the observed behavior but also provides insights into how to approach optimization in parallel computing scenarios.
