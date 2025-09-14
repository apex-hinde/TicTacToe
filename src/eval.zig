const std = @import("std");
const main = @import("main.zig");
const ArrayList = std.ArrayList;
var gpa = std.heap.DebugAllocator(.{}){};
const allocator = gpa.allocator();

//evaluates the current board state from -1 to 1, 1 is player 1 has a high chance of success and visa verse

pub fn eval_function(board: [3][3]u8, player: main.Players) f32{

    var eval:f32 = 0;

    eval += evaluate_line(board[0]);
    eval += evaluate_line(board[1]);
    eval += evaluate_line(board[2]);
    eval += evaluate_line([3]u8{board[0][0], board[1][0], board[2][0]});
    eval += evaluate_line([3]u8{board[0][1], board[1][1], board[2][1]});
    eval += evaluate_line([3]u8{board[0][2], board[1][2], board[2][2]});
    eval += evaluate_line([3]u8{board[0][0], board[1][1], board[2][1]});
    eval += evaluate_line([3]u8{board[2][0], board[1][1], board[0][2]});




// player 1 is positive, so if you are player 2 flips the value
    switch(player){
        main.Players.player_1 => return eval,
        main.Players.player_2 => return eval * -1,
    }
}


fn evaluate_line(line: [3]u8) f32{
    var counter1: u32 = 0;
    var counter2: u32 = 0;
    var tot: f32 = 0;

    for(line) |cell|{

        switch(cell) {
            1 => counter1 += 1,
            2 => counter2 += 1,
            else => {}
        }   
    }
    switch (counter1){
        1 => tot += 1,
        2 => tot += 10,
        3 => tot += 100,
        else => {}
    }
    switch (counter2){
        1 => tot -= 1,
        2 => tot -= 10,
        3 => tot -= 100,
        else => {}
    }


    return tot;
}

// returns a tupple the first value is player 1 the second value is player 2

