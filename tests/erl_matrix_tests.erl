-module(erl_matrix_tests).
-include_lib("eunit/include/eunit.hrl").

%% --- EUNIT TESTS FOR MATRIX MULTIPLICATION ---

%% 1. Test the Addition Helper
add_test() ->
    A = [[1, 2], [3, 4]],
    B = [[5, 6], [7, 8]],
    Expected = [[6, 8], [10, 12]],
    ?assertEqual(Expected, add(A, B)).

%% 2. Test the Padding Logic
pad_matrix_test() ->
    Input = [[1, 2, 3], [4, 5, 6]],
    Expected = [[1, 2, 3, 0],
                [4, 5, 6, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]],
    ?assertEqual(Expected, pad(Input)).

%% 3. Test the Main Strassen Wrapper
strassen_test() ->
    A = [[1, 2], [3, 4]],

    %Multiplying the Identity Matrix returns the original matrix
    Identity = [[1, 0], [0, 1]],
    ?assertEqual(A, standard_multiply(A, Identity)).

%% 4. Test an Uneven Matrix (Tests padding, math and trimming all at once)
uneven_strassen_test() ->
    A = [[1, 2, 3], [4, 5, 6]],
    B = [[7, 8], [9, 10], [11, 12]],
    Expected = [[58, 64], [139, 154]],
    ?assertEqual(Expected, standard_multiply(A, B)).

%% 5. Test the Base Case (1 X 1 Matrix)
base_case_test() ->
    A = [[5]],
    B = [[4]],
    Expected = [[20]],
    ?assertEqual(Expected, standard_multiply(A, B)).

%% 6. Test Negative Numbers
negative_numbers_test() ->
    A = [[-1, -2], [-3, -4]],
    B = [[1, 2], [3, 4]],
    Expected = [[-7, -10], [-15, -22]],
    ?assertEqual(Expected, standard_multiply(A, B)).

%% 7. Test the Zero Matrix
zero_matrix_test() ->
    A = [[1, 2, 3], 
         [4, 5, 6], 
         [7, 8, 9]],
    Zero = [[0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]],
    ?assertEqual(Zero, standard_multiply(A, Zero)),
    ?assertEqual(Zero, standard_multiply(Zero, A)).


%% 8. Test Extreme Asymmetry
extreme_asymetry_test() ->
    A = [[1], [2], [3], [4]],
    B = [[1, 2, 3, 4]],
    Expected = [[1, 2, 3, 4],
                [2, 4, 6, 8],
                [3, 6, 9, 12],
                [4, 8, 12, 16]],
    ?assertEqual(Expected, standard_multiply(A, B)).
