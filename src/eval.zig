const std = @import("std");
const main = @import("main.zig");

//evaluates the current board state from -1 to 1, 1 is player 1 has a high chance of success and visa verse

pub fn eval_function(board: [3][3]u8) f32{

    var eval:f32 = 0;
    const result: main.GameState =  main.is_winner(board);
    eval = switch(result){
        main.GameState.draw => 0,
        main.GameState.player_1_wins => eval+1,
        main.GameState.player_2_wins => eval-1,
        main.GameState.no_result => eval,
    };

//    std.debug.print("move: {}\n", .{result});

    return eval;


}




