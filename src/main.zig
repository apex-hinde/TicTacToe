//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const random_move = @import("random_move.zig");
const simumations = @import("simulations.zig");
const minimax = @import("minimax.zig");
const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;


const lib = @import("TicTacToe_lib");


pub const Players = enum(u8){
    player_1 = 1,
    player_2 = 2
};

pub const GameState = enum{
    no_result,
    player_1_wins,
    player_2_wins,
    draw
};


pub fn main() void {
//    var possible_moves = ArrayList(struct{u8,u8}).init(allocator);
//    defer possible_moves.deinit();
//    possible_moves.append(.{1,1});
//    var possible_moves_test = ArrayList(u8).init(allocator);
//    defer possible_moves_test.deinit();
 //   try possible_moves_test.append(8);
    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);



//    const board = get_empty_board();
//    const moves = minimax.get_possible_moves(board);
//   _ = moves; // autofix

//    const result = try minimax.main_game_loop();
//    std.debug.print("result: {any}", .{result});
}

pub fn get_empty_board() [3][3]u8{
    return [3][3]u8{
            [_]u8{0,0,0},
            [_]u8{0,0,0},
            [_]u8{0,0,0}
        };
}



// pure functions to work on a board.

pub fn move(board:[3][3]u8, x: u8,y: u8, player: Players) ![3][3]u8 {
    var temp_board = board;
    const temp_val: u8 = temp_board[y][x]; 
    if (1 == temp_val or 2 == temp_val){
        return error.InvalidMove;
    }
    else{
        temp_board[y][x] = @intFromEnum(player);
        return temp_board;
    }
}

pub fn is_winner(board: [3][3]u8) GameState{

    const player1_win = [1]u8{@intFromEnum(Players.player_1)} ** 3;
    const player2_win = [1]u8{@intFromEnum(Players.player_2)} ** 3;
    for (0..3) |i|{
        // for if a row is all 1 player
        if (std.mem.eql(u8, &board[i], &player1_win)){
            return GameState.player_1_wins;
        }
        if (std.mem.eql(u8, &board[i], &player2_win)){
            return GameState.player_2_wins;
        }
        var temp_col = [1]u8{0} ** 3;
    
        //for if a column is all 1 player
        for (0..3) |j|{
            temp_col[j] = board[j][i];
        }
        if (std.mem.eql(u8, &temp_col, &player1_win)){
            return GameState.player_1_wins;
        }
        if (std.mem.eql(u8, &temp_col, &player2_win)){
            return GameState.player_2_wins;
        }
        
    
    }
    //for the diagonal victories
    var temp_diag_up = [1]u8{0} ** 3;
    var temp_diag_down = [1]u8{0} ** 3;
    for(0..3) |i|{
        temp_diag_down[i] = board[i][i];
    }
    var i_down:u8 = 3;
    for(0..3) |i_up|{
        i_down = i_down-1;
        temp_diag_up[i_up] = board[i_down][i_up];
    }
    if (std.mem.eql(u8, &temp_diag_up, &player1_win)){
        return GameState.player_1_wins;
    }
    if (std.mem.eql(u8, &temp_diag_up, &player2_win)){
        return GameState.player_2_wins;
    }
    if (std.mem.eql(u8, &temp_diag_down, &player1_win)){
        return GameState.player_1_wins;
    }
    if (std.mem.eql(u8, &temp_diag_down, &player2_win)){
        return GameState.player_2_wins;
    }
    // to check if draw, simply if no cells contain a 0
    var is_draw = true;
        for (board) |row| {
            for (row) |cell| {
                if(cell == 0){
                    is_draw = false;
                }
            }
        }
        if(is_draw){
            return GameState.draw;
        }
    return GameState.no_result;
}

pub fn print_array(board: [3][3]u8) void{
    std.debug.print("{any}\n", .{board[0]});
    std.debug.print("{any}\n", .{board[1]});
    std.debug.print("{any}\n\n", .{board[2]});

}




// function to perform a move
// accepts coordinates, and player.
// returns false if invalid
// returns true if valid move










