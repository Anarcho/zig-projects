const std = @import("std");

// An attempt to create a DynamicArray in Zig (thanks tsoding)
pub fn DynamicArray(comptime T: type) type {
    return struct {
        items: []T,
        size: usize,
        capacity: usize,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = &[_]T{},
                .size = 0,
                .capacity = 0,
                .allocator = allocator,
            };
        }

        pub fn append(self: *@This(), item: T) !void {
            if (self.size >= self.capacity) {
                const new_capacity = if (self.capacity == 0) 8 else self.capacity * 2;
                const new_items = try self.allocator.realloc(self.items, new_capacity);
                self.items = new_items;
                self.capacity = new_capacity;
            }
            self.items[self.size] = item;
            self.size += 1;
        }

        pub fn get(self: @This(), index: usize) ?T {
            if (index >= self.size) return null;
            return self.items[index];
        }

        pub fn deinit(self: @This()) void {
            if (self.capacity > 0) {
                self.allocator.free(self.items);
            }
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arr = DynamicArray(i32).init(allocator);
    defer arr.deinit();

    try arr.append(10);
    try arr.append(20);
    try arr.append(30);

    const stdout = std.io.getStdOut().writer();
    for (0..arr.size) |i| {
        try stdout.print("Item {}: {}\n", .{ i, arr.get(i).? });
    }
}
