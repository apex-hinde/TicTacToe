const std = @import("std");
const main = @import("main.zig");
const random_move = @import("random_move.zig");
const minimax = @import("minimax.zig");

const ArrayList = std.ArrayList;
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();


pub fn simulate_random_move() !void{
    var draw_counter:u32 = 0;
    var player1_counter:u32 = 0;
    var player2_counter:u32 = 0;
    var i:u32 = 0;
    while(i<100000){
        const result: main.GameState = try random_move.main_game_loop(); 
        switch(result){
            main.GameState.draw => draw_counter = draw_counter+1,
            main.GameState.player_1_wins => player1_counter = player1_counter+1,
            main.GameState.player_2_wins => player2_counter = player2_counter+1,
            main.GameState.no_result => std.debug.print("error failed game\n", .{}),
        }
        i = i+1;
    }

    std.debug.print("amount of draws: {}\n", .{draw_counter});
    std.debug.print("amount of Player 1 wins: {}\n", .{player1_counter});
    std.debug.print("amount of Player 2 wins: {}\n", .{player2_counter});
    
}

pub fn simulate_minimax() !void{
    var draw_counter:u32 = 0;
    var player1_counter:u32 = 0;
    var player2_counter:u32 = 0;
    var i:u32 = 0;
    while(i<100){
        const result: main.GameState = try minimax.main_game_loop(); 
        switch(result){
            main.GameState.draw => draw_counter = draw_counter+1,
            main.GameState.player_1_wins => player1_counter = player1_counter+1,
            main.GameState.player_2_wins => player2_counter = player2_counter+1,
            main.GameState.no_result => std.debug.print("error failed game\n", .{}),
        }
        i = i+1;
    }

    std.debug.print("amount of draws: {}\n", .{draw_counter});
    std.debug.print("amount of Player 1 wins: {}\n", .{player1_counter});
    std.debug.print("amount of Player 2 wins: {}\n", .{player2_counter});
    
}


