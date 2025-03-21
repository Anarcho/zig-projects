const std = @import("std");

const LinkedListErrors = error{ NodeInitializationFail, OutOfMemory, ListInitialisationError };

const Node = struct {
    data: i32,
    next: ?*Node = null,

    pub fn init(allocator: std.mem.Allocator, data: i32, next: ?*Node) !*Node {
        var new_node = try allocator.create(Node);
        new_node.data = data;
        new_node.next = next;
        return new_node;
    }
};

const List = struct {
    head: ?*Node = null,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) List {
        return List{
            .head = null,
            .allocator = allocator,
        };
    }

    pub fn push_front(self: *@This(), data: i32) !void {
        const new_head = try Node.init(self.allocator, data, self.head);
        self.head = new_head;
    }

    pub fn traverse_nodes(self: *@This()) void {
        var current = self.head;
        while (current != null) {
            std.debug.print("{d}\n", .{current.?.data});
            const next = current.?.next;
            current = next;
        }
    }

    pub fn deinit(self: *@This()) void {
        var current = self.head;
        while (current != null) {
            const next = current.?.next;
            self.allocator.destroy(current.?);
            current = next;
        }
        self.head = null;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list = List.init(allocator);
    defer list.deinit();
    try list.push_front(19);
    try list.push_front(20);
    try list.push_front(40);
    list.traverse_nodes();
}
