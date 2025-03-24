const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var smp = std.heap.SmpAllocator(.{ .cpu_count = 2 });
    defer _ = smp.deinit();
    const allocator = smp

    var list = ArrayList(u8).init(allocator);
    defer list.deinit();

    try list.append('H');
    try list.append('E');
    try list.append('L');
    try list.append('L');
    try list.append('O');

    try list.appendSlice(" World!");

    std.debug.print("{s}\n", .{list.items});
}
