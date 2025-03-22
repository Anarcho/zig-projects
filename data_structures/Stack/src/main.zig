const std = @import("std");

const StackErrors = error{ NotEmpty, Empty };

pub fn Stack(comptime T: type) type {
    return struct {
        items: []T,
        size: usize,
        capacity: usize,
        top: i32,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = &[_]T{},
                .size = 0,
                .top = 0,
                .capacity = 0,
                .allocator = allocator,
            };
        }

        pub fn push(self: *@This(), item: T) !void {
            if (self.size >= self.capacity) {
                const new_capacity = if (self.capacity == 0) 8 else self.capacity * 2;
                const new_items = try self.allocator.realloc(self.items, new_capacity);

                self.items = new_items;
                self.capacity = new_capacity;
            }

            self.items[self.size] = item;
            self.size += 1;
            self.top += 1;
        }

        pub fn pop(self: *@This()) !T {
            if (self.top == 0) {
                return StackErrors.Empty;
            }
            self.size -= 1;
            self.top -= 1;
            const item = self.items[self.size];
            if (self.size <= self.capacity / 2 and self.capacity > 8) {
                self.items = try self.allocator.realloc(self.items, self.capacity / 2);
                self.capacity = self.capacity / 2;
            }
            return item;
        }

        pub fn peek(self: *@This()) i32 {
            if (self.top == 0) {
                return 0;
            }
            return self.top;
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

    var stack = Stack(i32).init(allocator);
    defer stack.deinit();

    try stack.push(10);
    try stack.push(20);
    std.debug.print("{d}\n", .{stack.peek()});
    _ = try stack.pop();
    try stack.push(30);
    try stack.push(40);
    std.debug.print("{d}\n", .{stack.peek()});
    std.debug.print("{d}\n", .{try stack.pop()});
}
