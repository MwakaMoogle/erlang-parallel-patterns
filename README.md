# Erlang Parallel Processing Benchmarks

A purely functional algorithmic suite built in Erlang to explore, benchmark, and parallelize compute-heavy tasks. 

This repository serves as the foundation for an Honours degree project focusing on multi-core hardware profiling and the Actor Model. It will eventually integrate the [Skel](https://github.com/Paraphrase/skel) algorithmic skeleton library to compare sequential vs. parallel execution times across various architectural patterns.

## Current Implementations

### 1. Matrix Multiplication (Standard)
An $O(n^3)$ implementation relying on list comprehensions and matrix transposition. 
* **Target Parallel Pattern:** Map / Worker Farm. 
* **Strategy:** Rows of matrix A can be mapped independently across CPU cores without inter-process communication.

### 2. Matrix Multiplication (Strassen's Method)
A highly recursive $O(n^{2.81})$ Divide-and-Conquer algorithm utilising dynamic zero-padding.
* **Target Parallel Pattern:** Divide and Conquer.
* **Strategy:** Recursively distributes the 7 intermediate matrix calculations ($M_1$ - $M_7$).

## Upcoming Features
* **Image Processing (Blur Filter):** A convolution matrix implementation to simulate spatial blurring, demonstrating parallel operations over 2D data arrays.
* **Skel Integration:** Wrapping existing algorithms in Skel parallelism templates to profile performance speedups with across large data sets.

## Compilation and Testing
The project includes a comprehensive EUnit test suite validating padding boundaries, mathematical accuracy, edge cases (zero matrices, negative values), and extreme matrix asymmetry.

** NOT YET IMPLEMENTED Automated Build (via Makefile):**
```bash
# Clean, compile, and run all unit tests
make

# Compile only
make compile
```
## Manual Execution via Erlang Shell:
``` bash
$ erlc *.erl
$ erl
1> A = [[1, 2], [3, 4]].
2> B = [[5, 6], [7, 8]].
3> erl_matrix:multiply(A, B).
4> erl_matrix:strassen_multiply(A, B).
```



