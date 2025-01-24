const std = @import("std");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    printf("Run `zig build test` to run the tests.\n", .{});
}

/// write to stdout using buffering with NO error handling
fn printf(comptime fmt: []const u8, args: anytype) void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);

    const stdout = bw.writer();
    stdout.print(fmt, args) catch unreachable;

    bw.flush() catch unreachable;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
