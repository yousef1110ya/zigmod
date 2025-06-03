const std = @import("std");
const print = std.debug.print;

var file_count: usize = 0;
var file_mtime: [100]i128 = undefined;

// const command: []u8 = "zig run index.zig";

pub fn watchFiles() !void {
    const path = "D:\\Zig codes\\zigmod";
    const allocater = std.heap.page_allocator;

    const cur_path = try std.fs.path.join(allocater, &.{ path, "" });
    print("just starting the watch files \n", .{});
    print("the current path is {s}\n", .{cur_path});
    defer allocater.free(cur_path);

    var dir = try std.fs.openDirAbsolute(cur_path, .{ .iterate = true });
    defer dir.close();

    while (true) {
        try dirWatch(dir, allocater, cur_path);
        file_count = 0;
    }
}

pub fn dirWatch(dir: std.fs.Dir, allocator: std.mem.Allocator, path: []u8) !void {
    var iterator = dir.iterate();
    while (try iterator.next()) |entry| {
        const full_path = try std.fs.path.join(allocator, &.{ path, entry.name });
        defer allocator.free(full_path);
        if (entry.kind == .directory) {
            if (entry.name[0] == '.') {
                continue;
            }
            var subDir = try std.fs.openDirAbsolute(full_path, .{ .iterate = true });
            defer subDir.close();

            try dirWatch(subDir, allocator, full_path);
            continue;
        }

        const stat = try std.fs.cwd().statFile(full_path);

        if (stat.mtime > file_mtime[file_count]) {
            print("executable changed {s}\n", .{entry.name});
            file_mtime[file_count] = stat.mtime;

            // in here we will create the code to do :
            // 1 - cancel the current process
            // 2 - start the process again just like nodemon

        }
        file_count += 1;
    }
}

pub fn main() !void {
    try watchFiles();
}
