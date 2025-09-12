const std = @import("std");
const ArrayList = std.ArrayList;

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("TicTacToe_lib");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
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
    for(0..9) |i|{
    const r = rand.intRangeAtMost(usize, 0, move_pool.items.len-1);

    const blank = move_pool.swapRemove(r);
    std.debug.print("removed item {any}\n",.{blank});
    std.debug.print("list of items {any}\n",.{move_pool.items});
    std.debug.print("{any}\n",.{i});


    }

}