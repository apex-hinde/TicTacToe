//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

const std = @import("std");
const ArrayList = std.ArrayList;

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("TicTacToe_lib");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const Players = enum(u8){
    player_1 = 1,
    player_2 = 2
};

const GameState = enum{
    no_result,
    player_1_wins,
    player_2_wins,
    draw
};




var board = [3][3]u8{
    [_]u8{0,0,0},
    [_]u8{0,0,0},
    [_]u8{0,0,0}
};
pub fn main() !void {
    std.debug.print("result is {any}", .{main_game_loop()});
}


fn main_game_loop() !GameState{
    const rand = std.crypto.random;

    var move_pool = ArrayList(struct{u8,u8}).init(allocator);
    defer move_pool.deinit();

    try move_pool.append(.{0,0});
    try move_pool.append(.{1,0});
    try move_pool.append(.{2,0});
    try move_pool.append(.{0,1});
    try move_pool.append(.{1,1});
    try move_pool.append(.{2,1});
    try move_pool.append(.{0,2});
    try move_pool.append(.{1,2});
    try move_pool.append(.{2,2});

    var game_state = GameState.no_result;
    var players_turn = Players.player_1;

    while(game_state == GameState.no_result){
        const r = rand.intRangeAtMost(usize, 0, move_pool.items.len-1);

        const blank = move_pool.swapRemove(r);
        const x, const y = blank;

        move(y,x,players_turn) catch |err| {
            std.debug.print("error, {any}\n", .{err});
        };   
        print_array();
 
        const result = is_winner();
        std.debug.print("result, {any}\n", .{result});
        if(result != GameState.no_result){
            game_state = result;
        }

        if(players_turn == Players.player_1){
            players_turn = Players.player_2;
        }
        
        else{
            players_turn = Players.player_1;
        }

    }
    return game_state;

    

 }

// function to perform a move
// accepts coordinates, and player.
// returns false if invalid
// returns true if valid move
fn move(y: u8,x: u8, player: Players) !void {
    const temp_val: u8 = board[y][x]; 
    if (1 == temp_val or 2 == temp_val){

        return error.InvalidMove;
    }
    else{
        board[y][x] = @intFromEnum(player);
    }
}




fn is_winner() GameState{
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






fn print_array() void{
    std.debug.print("{any}\n", .{board[0]});
    std.debug.print("{any}\n", .{board[1]});
    std.debug.print("{any}\n\n", .{board[2]});
}

