const std = @import("std");
const ArrayList = std.ArrayList;

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("TicTacToe_lib");
const main = @import("main.zig");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();


pub fn main_game_loop() !main.GameState{
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

    var game_state = main.GameState.no_result;
    var players_turn = main.Players.player_1;

    while(game_state == main.GameState.no_result){
        const r = rand.intRangeAtMost(usize, 0, move_pool.items.len-1);

        const blank = move_pool.swapRemove(r);
        const x, const y = blank;

        main.move(y,x,players_turn) catch |err| {
            std.debug.print("error, {any}\n", .{err});
        };   
        main.print_array();
 
        const result = main.is_winner();
        std.debug.print("result, {any}\n", .{result});
        if(result != main.GameState.no_result){
            game_state = result;
        }

        if(players_turn == main.Players.player_1){
            players_turn = main.Players.player_2;
        }
        
        else{
            players_turn = main.Players.player_1;
        }

    }
    return game_state;

    

 }