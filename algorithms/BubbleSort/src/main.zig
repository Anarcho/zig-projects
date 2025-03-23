const std = @import("std");

pub fn bubbleSort(comptime T: type, arr: []T) !void {
    // we need to get the number of items in the array to ensure we give each item in the array a chance to 'bubble up'
    const n = arr.len;
    // for each item in the array
    for (0..n) |i| {
        // we need this to determine the 0 based index number of each item
        for (0..n - i - 1) |j| {
            if (arr[j] > arr[j + 1]) { // if the current item is more then the item next to it, then it needs to swap.
                const temp = arr[j]; // we create a temporary constant to hold the lesser, as it will be overwritten in the array
                arr[j] = arr[j + 1]; // we now assign the lesser than value to the new index (overwriting the current array item, which is why we needed the temp)
                arr[j + 1] = temp; // now  we set the next item in the array to the greater than value
                // next iteration
            }
        }
    }
}

pub fn main() !void {
    var numbers = [_]i32{ 64, 23, 51, 634, 12, 90 };
    const stdout = std.io.getStdOut().writer();

    try bubbleSort(i32, numbers[0..]);

    try stdout.print("Sorted array: ", .{});
    try stdout.print("{any}\n", .{numbers});
}
