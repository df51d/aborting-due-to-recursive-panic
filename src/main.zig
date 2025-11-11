fn bar() !void {
    var t = try std.Thread.spawn(.{}, quaz, .{});
    t.join();
}

fn quaz() void {}

export fn foo() void {
    bar() catch @panic("err");
}

const std = @import("std");

pub fn main() !void {
    const lib_path = "./zig-out/lib/libdl_name.so";
    var modified_old: i128 = 0;

    var dl: ?std.DynLib = null;
    var foo_fn: ?*@TypeOf(foo) = null; // Adjust return type if needed

    while (true) {
        // Check mtime
        const file_stats = try std.fs.cwd().statFile(lib_path);
        const modified_new = file_stats.mtime;

        if (modified_old != modified_new) {
            modified_old = modified_new;

            // Close previous library
            if (dl) |*d| {
                d.close();
            }

            dl = try std.DynLib.open(lib_path);

            foo_fn = dl.?.lookup(@TypeOf(foo_fn.?), "foo");

            if (foo_fn == null) {
                std.debug.print("Failed to lookup 'foo'\n", .{});
            } else {
                std.debug.print("Reloaded library and function!\n", .{});
            }
        }

        if (foo_fn) |f| {
            f();
        }

        std.Thread.sleep(std.time.ns_per_ms * 15);
    }
}
