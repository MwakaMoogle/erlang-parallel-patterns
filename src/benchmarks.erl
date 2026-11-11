--module(benchmarks).
-export([run_all/0, run_matrix/1, run_blur/1]).

%% Generates an N x N matrix populated with random integers (1-255)
generate_matrix(N) ->
    [[rand:uniform(255) || _ <- lists:seq(1, N)] || _ <- lists:seq(1, N)].

