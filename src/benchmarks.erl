-module(benchmarks).
-export([run_all/0, run_matrix/1, run_blur/1]).

%% Generates an N x N matrix populated with random integers (1-255)
generate_matrix(N) ->
    [[rand:uniform(255) || _ <- lists:seq(1, N)] || _ <- lists:seq(1, N)].

%% Runs all the benchmarks across a standard dataset
run_all() ->
    Sizes = [16, 32, 64, 128, 256],
    io:format("~n=== MATRIX MULTIPLICATION BENCHMARKS ===~n"),
    lists:foreach(fun run_matrix/1, Sizes),
    
    io:format("~n=== IMAGE BLURRING BENCHMARKS ===~n"),
    lists:foreach(fun run_blur/1, Sizes),
    ok.

%% Benchmarks Standard and Strassen matrix multiplication
run_matrix(N) ->
    A = generate_matrix(N),
    B = generate_matrix(N),

    %% Get the time it takes to multiply
    {TimeStd, _} = timer:tc(erl_matrix, standard_multiply, [A, B]),
    {TimeStrassen, _} = timer:tc(erl_matrix, strassen_multiply, [A, B]),

    io:format("Matrix ~pw x ~ph | Standard: ~8.3f ms | Strassen: ~8.3f ms~n",
              [N, N, TimeStd / 1000.0, TimeStrassen / 1000.0]).

%% Benchmarks the 3x3 Box Blur convolution
run_blur(N) ->
    Image = generate_matrix(N),

    {TimeBlur, _} = timer:tc(image_blur, blur, [Image]),

    io:format("Image ~pw x ~ph | 3x3 Box Blur: ~8.3f ms~n",
             [N, N, TimeBlur / 1000.0]).
    
    
