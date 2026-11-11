-module(erl_matrix).
-export([strassen_multiply/2, standard_multiply/2]).
-ifdef(TEST).
-compile(export_all).
-endif.

%% -- Strassen's Method ---

%% Multiplying matricies recursively using Strassen’s algorithm
%% https://www.codelessgenie.com/blog/matrix-multiplication-recursive/#2-the-recursive-approach-fundamentals

%% If N is aready a power of 2, it returns N. Otherwise, it multiplies P by 2 recusively.
next_power_of_2(N) -> next_power_of_2(N, 1).
next_power_of_2(N, P) when P >= N -> P;
next_power_of_2(N, P) -> next_power_of_2(N, P * 2).

pad(M) ->
    Rows = length(M),
    Cols = length(hd(M)),

    MaxDim = max(Rows, Cols),
    Target = next_power_of_2(MaxDim),

    PaddedRows = [Row ++ lists:duplicate(Target - Cols, 0) || Row <- M],

    ExtraRows = lists:duplicate(Target - Rows, lists:duplicate(Target, 0)),

    PaddedRows ++ ExtraRows.

add(A, B) ->
    lists:zipwith(fun(RowA, RowB) -> lists:zipwith(fun(X, Y) -> X + Y end, RowA, RowB) end, A, B).

sub(A, B) ->
    lists:zipwith(fun(RowA, RowB) -> lists:zipwith(fun(X, Y) -> X - Y end, RowA, RowB) end, A, B).

%% Taking an NxN matix and splitting it into four N/2 x N/2 matricies (A11, A12, A21, A22).
split(M) -> 
    %% Find the half way point
    Half = length(M) div 2,

    {TopHalf, BottomHalf} = lists:split(Half, M),

    {A11, A12} = split_left_right(TopHalf, Half),
    {A21, A22} = split_left_right(BottomHalf, Half),

    {A11, A12, A21, A22}.
    
split_left_right(Rows, Half) ->
    lists:unzip([lists:split(Half, Row) || Row <- Rows]).

combine(C11, C12, C21, C22) ->
    Top = lists:zipwith(fun(RowLeft, RowRight) -> RowLeft ++ RowRight end, C11, C12),

    Bottom = lists:zipwith(fun(RowLeft, RowRight) -> RowLeft ++ RowRight end, C21, C22),

    Top ++ Bottom.

trim(PaddedMatrix, OriginalRows, OriginalCols) ->
    TrimmedRows = lists:sublist(PaddedMatrix, OriginalRows),

    [lists:sublist(Row, OriginalCols) || Row <- TrimmedRows].



strassen([[X]], [[Y]]) ->
    [[X * Y]];

%% Recursive 
strassen(A, B) ->
    %% Split the matricies into quadrents
    {A11, A12, A21, A22} = split(A),
    {B11, B12, B21, B22} = split(B),

    %% Calculate M1 through M7
    M1 = strassen(add(A11, A22), add(B11, B22)),
    M2 = strassen(add(A21, A22), B11),
    M3 = strassen(A11, sub(B12, B22)),
    M4 = strassen(A22, sub(B21, B11)),
    M5 = strassen(add(A11, A12), B22),
    M6 = strassen(sub(A21, A11), add(B11, B12)),
    M7 = strassen(sub(A12, A22), add(B21, B22)),

    %% combine into c quadrents
    C11 = add(sub(add(M1, M4), M5), M7),
    C12 = add(M3, M5),
    C21 = add(M2, M4),
    C22 = add(add(sub(M1, M2), M3), M6),

    combine(C11, C12, C21, C22).

strassen_multiply(A, B) ->
    OriginalRows = length(A),
    OriginalCols = length(hd(B)),

    %% Pad both matricies
    PaddedA = pad(A),
    PaddedB = pad(B),

    PaddedC = strassen(PaddedA, PaddedB),

    trim(PaddedC, OriginalRows, OriginalCols).

%% --- Noraml Method ---

%% Normal matrix multiplication
standard_multiply(A, B) ->
    B_Transposed = transpose(B),
    [ [ dot_product(RowA, ColB) || ColB <- B_Transposed ] || RowA <- A].

%% Calculates the dot product of two lists
dot_product(RowA, ColB) ->
    lists:sum(lists:zipwith(fun(X, Y) -> X * Y end, RowA, ColB)).

%% Transposes a matrix, collums become rows
transpose([[]|_]) ->
    [];
transpose(Matrix) ->
    [lists:map(fun hd/1, Matrix) | transpose(lists:map(fun tl/1, Matrix))].


