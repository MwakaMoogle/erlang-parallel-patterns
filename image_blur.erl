-module(image_blur).
-export([blur/1]).

blur(Image) ->
    blur_rows(Image).

%% Takes the entire image and grabs 3 rows at a time
blur_rows([Row1, Row2, Row3 | Rest]) ->
    [blur_cols(Row1, Row2, Row3) | blur_rows([Row2, Row3 | Rest])];
blur_rows(_) ->
    [].

%% Input is exactly 3 lists and slides across them left to right
blur_cols([P1, P2, P3 | Rest1], [P4, P5, P6 | Rest2], [P7, P8, P9 | Rest3]) ->
    %% Add all 9 pixels together the divide by 9 to get the avergage
    Avg = (P1 + P2 + P3 + P4 + P5 + P6 + P7 + P8 + P9) div 9,
    %% The new first pixel in the list is the average
    %% recursivly slide right by 1 pixel and repeat the process
    [Avg | blur_cols([P2, P3 | Rest1], [P5, P6 | Rest2], [P8, P9 | Rest3])];
blur_cols(_, _, _) ->
    [].
