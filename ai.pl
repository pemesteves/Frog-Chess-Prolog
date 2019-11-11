
%%%%%%%%%%%%%%%%%%%%
%                  %
%        AI        %
%                  %
%%%%%%%%%%%%%%%%%%%%


/**
 * Choose move
 * choose_move(+Board, +Player, +Level, -Move)
 * Chooses a move for the cpu to take.
 * A move is composed by the sequence of positions to jump to.
 *
 * Board -> Initial Board.
 * Player -> Player number.
 * Move -> List with all the jump positions of a move.
 */
choose_move(Board, Player, 1, Move) :-
    valid_moves(Board, Player, ListOfMoves), !,
    sort(0, @>=, ListOfMoves, [Move|_]), !.

choose_move(Board, Player, 2, Move) :-
    valid_moves(Board, Player, ListOfMoves), !,
    get_best_move(Board, Player, ListOfMoves, Move), !.

choose_move(Board, Player, 3, Move) :-
    valid_moves(Board, Player, ListOfMoves), !,
    %write('after valid_moves'), nl,
    minimax(Board, Player, ListOfMoves, Move, _, _).
   
minimax(Board, Player, [LastMove|[]], LastMove, Value, WinnerMove) :-
   % write('last minimax'),
    player_frog(Player, Frog), !, 
    execute_move(Board, Frog, LastMove, false, MidBoard), !,
    remove_outer_frogs(MidBoard, NewBoard), 
    next_player(Player, NextPlayer), !,
    %write('executed last move'), nl,
    get_max_value_from_next_player(NewBoard, NextPlayer, MaxValue, WinMove), !,
    %write('get_max value from next player'), nl,
    (
        WinMove = true,
        WinnerMove = LastMove;
        %write('MAX VALUE'), nl,
        WinMove = false,
        Value = MaxValue
    ), !.

minimax(Board, Player, [FirstMove|OtherMoves], BestMove, Value, WinnerMove) :-
    %write('start minimax'), nl,
    minimax(Board, Player, OtherMoves, OtherBestMove, OtherValue, WinMove),
    %write('end minimax'), nl,
    (
        nonvar(WinMove),
        %write('Non var'), nl,
        WinnerMove = WinMove,
        BestMove = WinnerMove;

        player_frog(Player, Frog), !, 
        execute_move(Board, Frog, FirstMove, false, MidBoard), !,
        remove_outer_frogs(MidBoard, NewBoard), 
        next_player(Player, NextPlayer), !,
        %write('executed move'), nl,
        get_max_value_from_next_player(NewBoard, NextPlayer, MaxValue, WMove), !,
        %write('get_max value from next player'), nl,
        (
            WMove = true,
            WinnerMove = FirstMove;

            WMove = false,
            %write('choose_best_move'), nl,
            choose_best_move_with_next_values(OtherValue, OtherBestMove, MaxValue, FirstMove, Value, BestMove)
        ), !
    ), !.

get_max_value_from_next_player(Board, Player, MaxValue, WinnerMove) :-
    write('valid_moves'), nl,
    (
        valid_moves(Board, Player, ListOfMoves), !,
        write('ola'), nl,
        get_best_move_helper(Board, Player, ListOfMoves, MaxValue, _, WinMove),
        write('alo'), nl,
        (
            var(WinMove),
            WinnerMove = false;
            WinnerMove = true
        );
        MaxValue = 0,
        WinnerMove = false
    ).

/**
 * Get best move
 * get_best_move(+Board, +Player, +ListOfMoves, -BestMove)
 * Gets the best move of a list of moves
 *
 * Board -> Game board.
 * Player -> Player number.
 * ListOfMoves -> List with all the possible moves of Player.
 * BestMove -> The best move for the Player.
 */
get_best_move(Board, Player, ListOfMoves, BestMove) :-
    get_best_move_helper(Board, Player, ListOfMoves, _, BestMove, _).

/**
 * Get best move helper
 * get_best_move_helper(+Board, +Player, +ListOfMoves, ?Value, -BestMove, ?WinnerMove)
 * Gets the best move of a list of moves
 *
 * Board -> Game board.
 * Player -> Player number.
 * ListOfMoves -> List with all the possible moves of Player.
 * Value -> The value of the best move.
 * BestMove -> The best move for the Player.
 * WinnerMove -> Auxiliar variable that is used to check if some move wins the game.
 */
get_best_move_helper(Board, Player, [LastMove|[]], Value, LastMove, _) :- value(Board, Player, Value).

get_best_move_helper(Board, Player, [FirstMove|OtherMoves], BestValue, BestMove, WinnerMove) :-
    player_frog(Player, Frog),
    execute_move(Board, Frog, FirstMove, false, MidBoard),
    remove_outer_frogs(MidBoard, NewBoard),
    (
        game_over(NewBoard, Player, Player), %if the game ends, and the player won, this is the best move
        BestMove = FirstMove,
        WinnerMove = BestMove; 
        
        value(NewBoard, Player, NewBoardValue), !,
        get_best_move_helper(Board, Player, OtherMoves, NewBestValue, NewBestMove, WinnerMove), !,
        (
            nonvar(WinnerMove), %if the get_best_move_helper returned a value, this is the best value
            BestMove = NewBestMove;

            var(WinnerMove), 
            choose_best_move(NewBoardValue, FirstMove, NewBestValue, NewBestMove, BestValue, BestMove), !
        )
    ).

/**
 * Choose best move
 * choose_best_move(+FirstValue, +FirstMove, +SecondValue, +SecondMove, -BestValue, -BestMove)
 * Chooses the best of two moves
 *
 * FirstValue -> The value of the first move.
 * FirstMove -> The first move.
 * SecondValue -> The value of the second move.
 * SecondMove -> The second move.
 * BestValue -> The value of the best move.
 * BestMove -> The best of the two moves.
 */
choose_best_move(FirstValue, FirstMove, SecondValue, _, BestValue, BestMove) :-
    FirstValue > SecondValue,
    BestValue = FirstValue,
    BestMove = FirstMove.

choose_best_move(FirstValue, _, SecondValue, SecondMove, BestValue, BestMove) :-
    FirstValue < SecondValue,
    BestValue = SecondValue,
    BestMove = SecondMove.

choose_best_move(FirstValue, FirstMove, SecondValue, SecondMove, BestValue, BestMove) :-
    length(FirstMove, FirstMoveLength),
    length(SecondMove, SecondMoveLength),
    (
        FirstMoveLength > SecondMoveLength,
        BestValue = FirstValue,
        BestMove = FirstMove;

        BestValue = SecondValue,
        BestMove = SecondMove
    ).

choose_best_move_with_next_values(FirstValue, FirstMove, SecondValue, _, BestValue, BestMove) :-
    FirstValue < SecondValue,
    BestValue = FirstValue,
    BestMove = FirstMove.

choose_best_move_with_next_values(FirstValue, _, SecondValue, SecondMove, BestValue, BestMove) :-
    FirstValue > SecondValue,
    BestValue = SecondValue,
    BestMove = SecondMove.

choose_best_move_with_next_values(FirstValue, FirstMove, SecondValue, SecondMove, BestValue, BestMove) :-
    length(FirstMove, FirstMoveLength),
    length(SecondMove, SecondMoveLength),
    (
        FirstMoveLength < SecondMoveLength,
        BestValue = FirstValue,
        BestMove = FirstMove;

        BestValue = SecondValue,
        BestMove = SecondMove
    ).

/**
 * Valid Moves
 * valid_moves(+Board, +Player, -ListOfMoves)
 * Checks all valid moves and returns them in a list
 *
 * Board -> Initial Board.
 * Player -> Player number.
 * ListOfMoves -> List of all the possible moves.
 */
valid_moves(Board, Player, ListOfMoves) :-
    player_frog(Player, Frog), 
    bagof(Pos, (valid_position(Board, Pos), get_position(Board, Pos, Frog)), FrogList), !,%Get the list of frogs
    generate_jumps(Board, FrogList, ListOfMoves), !.

/**
 * Generate jumps
 * generate_jumps(+Board, +Frog, +ListOfPositions, -ListOfJumpPositions)
 * Generates a list of list with all the possible moves of the cpu frogs
 *
 * Board -> Initial Board.
 * Frog -> Player Frog.
 * ListOfPositions -> List of the initial positions of the frogs.
 * ListOfJumpPositions -> List with all the moves that can be done by the cpu.
 */
generate_jumps(_, [], []) :- !.

generate_jumps(Board, [CurrFrogPos | Rest], JumpList) :-
    get_jumps(Board, [CurrFrogPos], CurrFrogJumps),
    generate_jumps(Board, Rest, RestFrogsJumps),
    append(CurrFrogJumps, RestFrogsJumps, JumpList).

/**
 * Get Jumps
 * get_jumps(+Board, +PrevJumps, -JumpList)
 * Gets all the new jumps possible given the current board and the previous jumps
 *
 * Board -> Game Board.
 * PrevJumps -> Previous Jumps.
 * JumpList -> The List of New Jumps.
 */
get_jumps(Board, PrevJumps, JumpList) :-
    last(PrevJumps, CurrPosition),
    (
        bagof(EndPos, frog_can_jump(Board, CurrPosition, EndPos), NewJumps);
        NewJumps = []
    ), !,

    (
        length(NewJumps, 0), JumpList = [];
        keep_jumping(Board, PrevJumps, NewJumps, JumpList)
    ), !.

/**
 * Keep Jumping
 * keep_jumping(+InBoard, +PreviousJumps, +NewDestinations, -JumpList)
 * Calls get_jump for each element of the NewDestinations list
 *
 * InBoard -> Initial Board.
 * PreviousJumps -> List with all the positions in this jump sequence.
 * NewDestinations -> List with the new possible destinations.
 * JumpList -> List with all the jumps.
 */
keep_jumping(_, _, [], []) :- !.
keep_jumping(InBoard, PrevJumps, [CurrDest | Rest], [NewJumpSequence | JumpList]) :-
    % determine sequence of jumps until this one
    append(PrevJumps, [CurrDest], NewJumpSequence),

    % get board after the last jump
    last(PrevJumps, CurrPosition), % get current position
    get_position(InBoard, CurrPosition, Frog), % determine frog
    middle_position(CurrPosition, CurrDest, MidPos), % get middle position
    jump(InBoard, CurrPosition, MidPos, CurrDest, Frog, NewBoard), % jump

    % keep jumping from this position
    get_jumps(NewBoard, NewJumpSequence, JumpsFromThisPosition),

    % continue to the other jump destinations
    keep_jumping(InBoard, PrevJumps, Rest, JumpsFromNextPosition),

    % merge 2 lists of jumps
    append(JumpsFromThisPosition, JumpsFromNextPosition, JumpList).

/**
 * Execute Move
 * execute_move(+InputBoard, +Frog, +PositionsList, +DisplayMove, -OutputBoard)
 * Executes a cpu move
 * 
 * InputBoard -> Initial Board.
 * Frog -> CPU Frog.
 * PositionsList -> List of all the positions of a cpu move.
 * DisplayMove -> Indicates if the move should be displayed.
 * OutputBoard -> Final Board.
 */
execute_move(InBoard, Frog, PositionList, true, OutputBoard) :-
    execute_move_helper(InBoard, Frog, PositionList, 1, OutputBoard).

execute_move(InBoard, Frog, PositionList, false, OutputBoard) :-
    execute_move_helper(InBoard, Frog, PositionList, OutputBoard).

/**
 * Execute Move Helper
 * execute_move_helper(+InputBoard, +Frog, +PositionsList, +JumpNumber, -OutputBoard)
 * Executes a cpu move with display
 * 
 * InputBoard -> Initial Board.
 * Frog -> CPU Frog.
 * PositionsList -> List of all the positions of a cpu move.
 * JumpNumber -> Number of the jump that is being executed.
 * OutputBoard -> Final Board.
 */
execute_move_helper(Board, _, [_ | []], _, Board) :- !. % If there is only one position, there are no more jumps

execute_move_helper(InBoard, Frog, [StartPos, EndPos| OtherPos], JumpN, OutBoard) :-
    middle_position(StartPos, EndPos, MidPos),
    jump(InBoard, StartPos, MidPos, EndPos, Frog, NewBoard),
    player_frog(Player, Frog),
    display_game(NewBoard, Player, JumpN),
    display_cpu_jump(StartPos, EndPos),
    wait_for_input,
    NextJumpN is JumpN +1,
    execute_move_helper(NewBoard, Frog, [EndPos| OtherPos], NextJumpN, OutBoard).


/**
 * Execute Move Helper
 * execute_move_helper(+InputBoard, +Frog, +PositionsList, -OutputBoard)
 * Executes a cpu move without display
 * 
 * InputBoard -> Initial Board.
 * Frog -> CPU Frog.
 * PositionsList -> List of all the positions of a cpu move.
 * OutputBoard -> Final Board.
 */
execute_move_helper(Board, _, [_| []], Board) :- !. % If there is only one position, there are no more jumps

execute_move_helper(InBoard, Frog, [StartPos, EndPos| OtherPos], OutBoard) :-
    middle_position(StartPos, EndPos, MidPos),
    jump(InBoard, StartPos, MidPos, EndPos, Frog, NewBoard),
    execute_move_helper(NewBoard, Frog, [EndPos| OtherPos], OutBoard).