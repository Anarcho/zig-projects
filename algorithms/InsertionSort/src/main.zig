const std = @import("std");

pub fn insertionSort(comptime T: type, arr: []T) !void {
    for (arr[1..], 1..) |_, i| {
        const key = arr[i];
        var j = i;

        while (j > 0 and arr[j - 1] > key) : (j -= 1) {
            arr[j] = arr[j - 1];
        }
        arr[j] = key;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var numbers = [_]i32{ 125, 12, 3, 14 };

    try insertionSort(i32, numbers[0..]);

    try stdout.print("{any}\n", .{numbers});
}
