const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    const cwd = fs.cwd();
    const cwd_dir = try cwd.openDir(".", .{});
    var it = cwd_dir.iterate();

    while (try it.next()) |entry| {
        const name = entry.name;
        const kind = entry.kind;

        if (kind == fs.Dir.Entry.Kind.Directory) {
            std.debug.warn("dir : {}\n", .{name});
        } else if (kind == fs.Dir.Entry.Kind.File) {
            std.debug.warn("file: {}\n", .{name});
        }
    }
}

