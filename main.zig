const std = @import("std");
const fs = std.fs;
const heap = std.heap;
const process = std.process;

const open_opts = fs.Dir.OpenDirOptions{ .iterate = true };

pub fn main() !void {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    const cwd = fs.cwd();
    var target_dir = if (args.len < 2) cwd.openDir(".", open_opts) else cwd.openDir(args[1], open_opts);

    if (target_dir) |*dir| {
        defer dir.close();
        var it = dir.iterate();
        while (try it.next()) |entry| {
            const name = entry.name;
            const kind = entry.kind;

            if (kind == fs.Dir.Entry.Kind.Directory) {
                std.debug.warn("dir : {}\n", .{name});
            } else if (kind == fs.Dir.Entry.Kind.File) {
                std.debug.warn("file: {}\n", .{name});
            }
        }
    } else |err| {
        std.debug.warn("err! {}\n", .{err});
    }
}
