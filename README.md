# Erlang Parallel Processing Benchmarks

A purely functional algorithmic suite built in Erlang to explore, benchmark, and parallelize compute-heavy tasks. 

This repository serves as the single-core baseline for an Honours project focusing on multi-core hardware profiling, the Actor Model, and algorithmic skeletons. The codebase is prepped to be integrated into the [Skel](https://github.com/Paraphrase/skel) library to compare sequential versus parallel execution times across various architectural patterns.

## Current Implementations

### 1. Image Processing: 2D Convolution Blur (`image_blur.erl`)
A purely functional implementation of a $3 \times 3$ Box Blur (Averaging) filter.
* **Mechanism:** Uses recursive list pattern matching to slide a 9 pixel averaging kernel across a 2D grid, smoothing high frequency data without mutable state or `for` loops. Automatically trims the 1 pixel outer boundary.

### 2. Matrix Multiplication: Strassen's Method (`erl_matrix.erl`)
A highly recursive $O(n^{2.81})$ Divide-and-Conquer algorithm utilizing dynamic zero-padding.
* **Mechanism:** Subdivides matrices into quadrants and recursively calculates 7 intermediate matrices ($M_1$ - $M_7$).

### 3. Matrix Multiplication: Standard (`erl_matrix.erl`)
An $O(n^3)$ implementation relying on matrix transposition and list comprehensions.
* **Mechanism:** Calculates dot products of rows and columns.

## Compilation and Testing
The project includes a comprehensive EUnit test suite validating padding boundaries, mathematical accuracy, edge cases, and extreme matrix asymmetry.

## Compile and execution
```bash
erlc *.elr
erl
```

### Running the Image Blur:
```erlang
1> Image = [[10, 10, 10, 10], [10, 90, 90, 10], [10, 90, 90, 10], [10, 10, 10, 10]].
2> image_blur:blur(Image).
%% Output: [[38, 38], [38, 38]]
```

### Running Matrix Multiplication
```erlang
1> A = [[1, 2], [3, 4]].
2> B = [[5, 6], [7, 8]].
3> erl_matrix:standard_multiply(A, B).
4> erl_matrix:strassen_multiply(A, B). %% Strassen wrapper
```
(_Note: Erlang interprets lists of integers in the printable ASCII range as strings. Use io:format("~w~n", [Result]) to print raw integers_).

## Resources & References
* [Learn You Some Erlang for Great Good!](https://learnyousomeerlang.com/)
* [What is Image Blurring - GeeksforGeeks](https://www.geeksforgeeks.org/computer-science-fundamentals/what-is-image-blurring/)
* [Matrix Multiplication - Geeks for Geeks](https://www.geeksforgeeks.org/dsa/strassens-matrix-multiplication/)
* [Matrix Multiplication | Recursive: A Deep Dive into Divide-and-Conquer](https://www.codelessgenie.com/blog/matrix-multiplication-recursive/#2-the-recursive-approach-fundamentals)
* [Strassen Algorithm Visually Explained](https://www.youtube.com/watch?v=2IgZuVGwEb0)
* [2.9 Strassens Matrix Multiplication](https://www.youtube.com/watch?v=0oJyNmEbS4w)




