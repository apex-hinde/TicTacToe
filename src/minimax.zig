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
        var empty_spaces: u32 = 0;
        for(board)|row|{
            for(row)|cell|{
                if(cell==0){
                    empty_spaces += 1;
                }
            }
        }

        const val, const move = minimax(0, 2,  true, board, players_turn);
//        _ = val; // val not needed exept for debugging
        const x, const y = move;

        std.debug.print("player {}, ", .{players_turn});
        board = try main.move(board, y, x, players_turn);
        const result = main.is_winner(board);
        game_state = result;
        players_turn = 
            switch(players_turn){
                main.Players.player_1 => main.Players.player_2,
                main.Players.player_2 => main.Players.player_1
            };
        std.debug.print("eval of next move: {}\n", .{val});
        main.print_array(board);
        std.debug.print("move: {any}\n", .{move});


    }
    return game_state;
}

/// dynamically adjust max height to always arrive at max level
/// use player input so the computer always is player 1

fn minimax(depth: u32, max_height: u32, is_max: bool, board: [3][3]u8, player: main.Players) struct{i32, struct{u8,u8}}{
   
    var possible_moves: ArrayList(struct{u8,u8}) = ArrayList(struct{u8,u8}).init(allocator);

    for (board, 0..) |row, row_index| {
        for (row, 0..) |cell, col_index| {

            if(cell == 0){
                try possible_moves.append(.{@intCast(col_index), @intCast(row_index)});
            }
        }
    }
    const moves = try possible_moves.toOwnedSlice(); 
    if(true){
        return(.{eval.eval_function(board, player), moves[0]});
    }
    if(depth == max_height){
        return(.{eval.eval_function(board, player), moves[0]});
        
    }
    
    if(is_max){
        var best_score: i32 = -100000;
        var best_move = .{0,0};
        for(moves) |move|{
            const x, const y = move;
            const new_board = main.move(board, x, y, player);
            const score = minimax(depth+1, max_height, false, new_board, player);
            if(score>best_score){
                best_score = score;
                best_move = move;
            }

        }
        return .{best_score, best_move};
    }
    if(!is_max){
        var best_score: i32 = 100000;
        var best_move = .{0,0};
        for(moves) |move|{
            const x, const y = move;
            const new_board = main.move(board, x, y, player);
            const score = minimax(depth+1, max_height, true, new_board, player);
            if(score<best_score){
                best_score = score;
                best_move = move;
            }

        }
        return .{best_score, best_move};
    }
}

