const std = @import("std");

const QueueErrors = error{EmptyQueue};

pub fn Queue(comptime T: type) type {
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

        pub fn enqueue(self: *@This(), item: T) !void {
            if (self.size >= self.capacity) {
                // determining the size of the capacity
                const new_capacity = if (self.capacity == 0) 8 else self.capacity * 2;
                const new_items = try self.allocator.realloc(self.items, new_capacity);

                self.capacity = new_capacity;
                self.items = new_items;
            }
            self.items[self.size] = item;
            self.size += 1;
        }

        pub fn dequeue(self: *@This()) !T {
            if (self.size == 0) {
                return error.EmptyQueue;
            }
            const v = self.items[0];
            std.mem.copyForwards(T, self.items[0..], self.items[1..]);
            self.size -= 1;
            if (self.size <= self.capacity / 2) {
                const new_capacity = if ((self.capacity / 2) <= 8) 8 else self.capacity / 2;
                const new_items = try self.allocator.realloc(self.items, self.size);
                self.capacity = new_capacity;
                self.items = new_items;
            }
            return v;
        }

        pub fn deinit(self: *@This()) void {
            if (self.size != 0) {
                self.allocator.free(self.items);
            }
        }
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var queue = Queue(i32).init(allocator);
    try queue.enqueue(10);
    try queue.enqueue(20);
    try queue.enqueue(30);

    _ = try queue.dequeue();
    const x = try queue.dequeue();

    std.debug.print("{d}\n", .{x});

    defer queue.deinit();
}
