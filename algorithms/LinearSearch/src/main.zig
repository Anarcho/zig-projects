const std = @import("std");

pub fn LinearSearch(arr: [5]i32, x: i32) i32 {
    var counter: i32 = 0;
    for (arr) |value| {
        if (value == x) {
            return counter;
        }
        counter += 1;
    }
    return 0;
}

pub fn main() !void {
    const arr = [5]i32{ 2, 14, 18, 212, 10 };
    const v: i32 = 18;
    const x: i32 = LinearSearch(arr, v);
    std.debug.print("{d}\n", .{x});
}
