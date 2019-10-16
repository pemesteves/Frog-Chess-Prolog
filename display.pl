:- include('game_state.pl').
:- include(library(ansi_term)).


player_frog(1, pink).
player_frog(2, green).

frog_color(pink, magenta).
frog_color(green, green).


/* Display Game 
 * display_game(+Board, +Player)
 *
 * Board -> List with the board representation
 * Player -> Number of the player to make the next move
 * Characters used for representation: 
 *          - Y -> frog from the green player
 *          - P -> frog from the pink player
 *          - Other caracters are used to represent the board 
 */
display_game(Board, Player) :-
    player_frog(Player, _), nl,
    initialBoard(Board),
    display_board(Board), nl,
    display_turn(Player).

display_turn(Player) :-
    player_frog(Player, Frog),
    frog_color(Frog, Color),

    write('                     '), display_frog_ascii_1(Frog), nl,
    write('  /===============\\  '), display_frog_ascii_2(Frog), nl,
    write('  | Player '), ansi_format([fg(Color)], '~d', [Player]), write(' Turn |'), write('  '), display_frog_ascii_3(Frog), nl,
    write('  \\===============/  '), display_frog_ascii_4(Frog), nl,
    write('                     '), display_frog_ascii_5(Frog), nl, nl.


display_board(Board) :- display_board_helper(Board, 0).

/*

*/
display_board_helper([], _).
display_board_helper([Curr_Row|Rest], RowN) :-
    RowN >= 0,
    RowN < 8,
    display_row(Curr_Row, RowN), 
    NextRow is RowN + 1,
    display_board_helper(Rest, NextRow).

/*

*/
display_row(Row, 0) :-
    write('  '), display_col_head(0), nl,
    write('  '), display_top(0), nl,
    display_row_frogs(Row, 1),    
    write('  '), display_div(0), nl.

display_row(Row, 7) :-
    display_row_frogs(Row, 8),
    write('  '), display_bottom(0), nl.

display_row(Row, RowN) :-
    RowN > 0,   
    RowN < 7,
    N is RowN+1,
    display_row_frogs(Row, N),
    write('  '), display_div(0), nl.

/*

*/
display_row_frogs(Row, N) :-
    write('  '), display_frog_row_1(Row, 0), nl,
    write('  '), display_frog_row_2(Row, 0), nl,
    ansi_format([fg(blue)], '~w', [N]), write(' '), display_frog_row_3(Row, 0), nl,
    write('  '), display_frog_row_4(Row, 0), nl,
    write('  '), display_frog_row_5(Row, 0), nl.


/*

*/
display_frog_row_1([], _).

display_frog_row_1([Frog|Rest], 0) :-    
    put_code(186),
    display_frog_ascii_1(Frog),
    put_code(186),
    display_frog_row_1(Rest, 1).


display_frog_row_1([Frog|Rest], ColN) :-
    ColN > 0,
    ColN < 8,
    display_frog_ascii_1(Frog),
    put_code(186),
    NextCol is ColN + 1,
    display_frog_row_1(Rest, NextCol).


/*

*/
display_frog_row_2([], _).

display_frog_row_2([Frog|Rest], 0) :-    
    put_code(186),
    display_frog_ascii_2(Frog),
    put_code(186),
    display_frog_row_2(Rest, 1).


display_frog_row_2([Frog|Rest], ColN) :-
    ColN > 0,
    ColN < 8,
    display_frog_ascii_2(Frog),
    put_code(186),
    NextCol is ColN + 1,
    display_frog_row_2(Rest, NextCol).


/*

*/
display_frog_row_3([], _).

display_frog_row_3([Frog|Rest], 0) :-    
    put_code(186),
    display_frog_ascii_3(Frog),
    put_code(186),
    display_frog_row_3(Rest, 1).


display_frog_row_3([Frog|Rest], ColN) :-
    ColN > 0,
    ColN < 8,
    display_frog_ascii_3(Frog),
    put_code(186),
    NextCol is ColN + 1,
    display_frog_row_3(Rest, NextCol).


/*

*/
display_frog_row_4([], _).

display_frog_row_4([Frog|Rest], 0) :-    
    put_code(186),
    display_frog_ascii_4(Frog),
    put_code(186),
    display_frog_row_4(Rest, 1).

display_frog_row_4([Frog|Rest], ColN) :-
    ColN > 0,
    ColN < 8,
    display_frog_ascii_4(Frog),
    put_code(186),
    NextCol is ColN + 1,
    display_frog_row_4(Rest, NextCol).


/*

*/
display_frog_row_5([], _).

display_frog_row_5([Frog|Rest], 0) :-    
    put_code(186),
    display_frog_ascii_5(Frog),
    put_code(186),
    display_frog_row_5(Rest, 1).

display_frog_row_5([Frog|Rest], ColN) :-
    ColN > 0,
    ColN < 8,
    (
        ColN = 0,
        put_code(186);
        1 = 1
    ),
    display_frog_ascii_5(Frog),
    put_code(186),
    NextCol is ColN + 1,
    display_frog_row_5(Rest, NextCol).

/*

*/
display_col_head(7) :-
    write('        '),
    ansi_format([fg(blue)], '~w', [8]),
    write('       ').

display_col_head(ColN) :-
    ColN >= 0,
    ColN < 7,
    N is ColN+1,
    write('        '),
    ansi_format([fg(blue)], '~w', [N]),
    write('       '),
    NextCol is ColN + 1,
    display_col_head(NextCol).


/*

*/
display_top(0) :-
    put_code(201),
    display_div_line(15),
    put_code(203),
    display_top(1).

display_top(7) :-
    display_div_line(15),
    put_code(187).

display_top(ColN) :-
    ColN > 0,
    ColN < 7,
    display_div_line(15),
    put_code(203),
    NextCol is ColN + 1,
    display_top(NextCol).


/*

*/
display_bottom(0) :-
    put_code(200),
    display_div_line(15),
    put_code(202),
    display_bottom(1).

display_bottom(7) :-
    display_div_line(15),
    put_code(188).

display_bottom(ColN) :-
    ColN > 0,
    ColN < 7,
    display_div_line(15),
    put_code(202),
    NextCol is ColN + 1,
    display_bottom(NextCol).


/*

*/
display_div(0) :-
    put_code(204),
    display_div_line(15),
    put_code(206),
    display_div(1).

display_div(7) :-
    display_div_line(15),
    put_code(185).

display_div(ColN) :-
    ColN > 0,
    ColN < 7,
    (
        ColN = 0, put_code(204);
        1 = 1
    ),
    display_div_line(15),
    put_code(206),
    NextCol is ColN + 1,
    display_div(NextCol).

display_div_line(0).
display_div_line(Count) :-
    Count > 0,
    put_code(205),
    %put_char('\u2550'),
    N is Count-1,
    display_div_line(N).

/*

*/
display_frog_ascii_1(X) :-
    X = empty,
    write('               ').

display_frog_ascii_1(X) :-
    X \= empty,
    frog_color(X, Color),
    ansi_format([fg(Color)], '~w', ['    (\')=(\')    ']).
    
/*

*/
display_frog_ascii_2(X) :-
    X = empty,
    write('               ').

display_frog_ascii_2(X) :-
    X \= empty,
    frog_color(X, Color),
    ansi_format([fg(Color)], '~w', ['  __(  "  )__  ']).
    
/*

*/
display_frog_ascii_3(X) :-
    X = empty,
    write('               ').

display_frog_ascii_3(X) :-
    X \= empty,
    frog_color(X, Color),
    ansi_format([fg(Color)], '~w', [' / _/\'---\'\\_ \\ ']).
    
/*

*/
display_frog_ascii_4(X) :-
    X = empty,
    write('               ').

display_frog_ascii_4(X) :-
    X \= empty,
    frog_color(X, Color),
    ansi_format([fg(Color)], '~w', ['_\\\\ \\\\   // //_']).
    
/*

*/
display_frog_ascii_5(X) :-
    X = empty,
    write('               ').

display_frog_ascii_5(X) :-
    X \= empty,
    frog_color(X, Color),
    ansi_format([fg(Color)], '~w', ['>__)/_\\-/_\\(__<']).