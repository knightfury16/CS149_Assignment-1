# Analysis

## Performance Comparison

| Input Range | Serial (ms) | ISPC (ms) | Task ISPC (ms) | ISPC Speedup | Task ISPC Speedup |
|-------------|-------------|-----------|----------------|--------------|-------------------|
| 1.0 - 3.0   | 628.694     | 166.928   | 11.694         | 3.77x(default)| 53.76x           |
| 1.0 - 1.5   | 250.266     | 27.672    | 8.373          | 9.04x(best)  | 29.89x            |
| 1.5 - 2.0   | 293.532     | 36.307    | 8.064          | 8.08x        | 36.40x            |
| 2.0 - 2.5   | 364.670     | 64.645    | 8.844          | 5.64x        | 41.23x            |
| 2.5 - 3.0   | 748.133     | 131.797   | 11.250         | 5.68x        | 66.50x            |
| All 1.0     | 11.697      | 9.148     | 6.476          | 1.28x(worst) | 1.81x             |

### Observations:

1. The Task ISPC implementation consistently outperforms both the Serial and standard ISPC implementations across all input ranges.
2. The performance gain is most significant for larger input ranges, with the 2.5 - 3.0 range showing the highest speedup for Task ISPC (66.50x).
3. When all input values are 1.0, the performance difference is less pronounced, likely due to reduced computational complexity.
4. The standard ISPC implementation shows variable speedup compared to the Serial version, ranging from 1.28x to 9.04x depending on the input range.
5. Task ISPC shows more consistent and significant speedups across different input ranges, except when all inputs are 1.0.

These results demonstrate the effectiveness of ISPC, particularly with task parallelism, in optimizing the square root calculation across various input ranges.
