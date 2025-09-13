const std = @import("std");
const main = @import("main.zig");
const eval = @import("eval.zig");

const ArrayList = std.ArrayList;
const allocator = std.heap.smp_allocator;

pub fn main_game_loop() !main.GameState{
    var board = main.get_empty_board();
    var game_state = main.GameState.no_result;
    var players_turn = main.Players.player_1;
    
    while(game_state == main.GameState.no_result){

        const val, const move = try minimax(0, 4,  true, board, players_turn);
//        _ = val; // val not needed exept for debugging
        const x, const y = move;


        board = try main.move(board, y, x, players_turn);
        const result = main.is_winner(board);
        game_state = result;
        players_turn = 
            switch(players_turn){
                main.Players.player_1 => main.Players.player_2,
                main.Players.player_2 => main.Players.player_1
            };
        std.debug.print("player {}, eval of next move: {}\n", .{players_turn, val});
        main.print_array(board);
        std.debug.print("move: {any}\n", .{move});


    }
    return game_state;
}
fn minimax(depth: u32, max_hight: u32, is_max: bool, board: [3][3]u8, player: main.Players) !struct{f32, struct{u8,u8}}{
    const rand = std.crypto.random;

    var possible_boards = ArrayList([3][3]u8).init(allocator);
    defer possible_boards.deinit();
    const next_player = 
    switch(player){
        main.Players.player_1 => main.Players.player_2,
        main.Players.player_2 => main.Players.player_1
    };
    if(depth >= max_hight){

        const eval_local = eval.eval_function(board);
        return .{eval_local, .{0,0}};

    }


    var possible_moves_check: ArrayList(struct{u8,u8}) = ArrayList(struct{u8,u8}).init(allocator);

    defer possible_moves_check.deinit();
    for (board, 0..) |row, row_index| {
        for (row, 0..) |cell, col_index| {
            if(cell == 0){
                try possible_moves_check.append(.{@intCast(col_index), @intCast(row_index)});
            }
        }
    }
    if(possible_moves_check.items.len==1 and depth != max_hight){

        const eval_local = eval.eval_function(board);
        for (board, 0..) |row, y| {
            for (row, 0..) |cell, x| {
                if(cell == 0){
                    return .{eval_local, .{@intCast(x), @intCast(y)}};
                }
            }
        }
    }

    if(is_max){

        var possible_moves: ArrayList(struct{u8,u8}) = ArrayList(struct{u8,u8}).init(allocator);

        defer possible_moves.deinit();

        for (board, 0..) |row, row_index| {
            for (row, 0..) |cell, col_index| {
                if(cell == 0){
                    try possible_moves.append(.{@intCast(col_index), @intCast(row_index)});
                }
            }
        }            
        var max_value: ArrayList(struct{f32, struct{u8,u8}}) = ArrayList(struct{f32, struct{u8,u8}}).init(allocator);
        defer max_value.deinit();
        var max_value_num: f32 = -10000;
        for(possible_moves.items) |temp_move|{
            const x:u8, const y:u8 = temp_move;
            const temp_board: [3][3]u8 = try main.move(board, y, x, player);
            const temp_depth = depth+1;

            const value: f32, const move: struct{u8, u8} =  try minimax(temp_depth, max_hight, false, temp_board, next_player);
            _ = move; // autofix
            if(value>=max_value_num){
                
                try max_value.append(.{value, temp_move});
                max_value_num = value;
            }
        }

        const result: struct{f32, struct{u8,u8}}=
        switch (max_value.items.len){
            1 => max_value.getLast(),
            else => 
                
                max_value.swapRemove(rand.intRangeAtMost(usize, 0, max_value.items.len-1))
        };
        return (result);
    }

    if(!is_max){

        var possible_moves: ArrayList(struct{u8,u8}) = ArrayList(struct{u8,u8}).init(allocator);

        defer possible_moves.deinit();

        for (board, 0..) |row, row_index| {
            for (row, 0..) |cell, col_index| {
                if(cell == 0){
                    try possible_moves.append(.{@intCast(col_index), @intCast(row_index)});
                }
            }
        }

        var min_value: ArrayList(struct{f32, struct{u8,u8}}) = ArrayList(struct{f32, struct{u8,u8}}).init(allocator);

        defer min_value.deinit();
        var min_value_num: f32 = 10000;

        for(possible_moves.items) |temp_move|{
            const x:u8, const y:u8 = temp_move;
            const temp_board = try main.move(board, y, x, player);
            const temp_depth = depth+1;
            const value, const move = try minimax(temp_depth, max_hight, true, temp_board, next_player);
            _ = move; // autofix
            if(value<=min_value_num){
                min_value.append(.{value, temp_move}) catch |err| return err;
                min_value_num = value;
            }
        }
        const result: struct{f32, struct{u8,u8}}=
        switch (min_value.items.len){
            1 => min_value.getLast(),
            else => 
                min_value.swapRemove(rand.intRangeAtMost(usize, 0, min_value.items.len-1))
        };
        return (result);

    }
    else{
        return error.OutOfScope;
    }




}

