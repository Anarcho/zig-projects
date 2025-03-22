const std = @import("std");

const QueueErrors = error{EmptyQueue};

pub fn Queue(comptime T: type) !type {
    return struct {
        items: []T,
        size: usize,
        capacity: usize,
        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .items = &[_]T{},
                .size = 0,
                .capacty = 0,
                .allocator = allocator,
            };
        }

        pub fn enqueue(self: *@This(), item: T) void {
            if (self.size <= self.capacity) {
                const new_capacity = if (self.capacity == 0) 8 else self.capacity * 2;
                const new_items = try self.allocator.realloc(self.items, new_capacity);

                self.items = new_items;
                self.capacity = new_capacity;
            }
            self.items[self.size] = item;
            self.size += 1;
        }

        pub fn dequeue(self: *@This()) !T {
            if (self.size == 0) {
                return error.EmptyQueue;
            }

            var return_item: T = undefined;

            self.size -= 1;

            if (self.size <= self.capacity / 2 and self.capacity != 0) {
                const new_capacity = self.capacity / 2;
                return_item = self.item[0];

                const new_items = try self.allocator.realloc(self.items[1..], new_capacity);
                self.items = new_items;
                self.capacity = new_capacity;
            }

            self.items = self.
        }

        pub fn deinit(self: *@This()) void {
            if (self.size != 0) {
                self.allocator.free(self.items);
            }
        }
    };
}
