const std = @import("std");
const print = std.debug.print;

pub fn watchFiles() !void {
    const allocater = std.heap.page_allocator;
    // getting the current path for the application and then tests how to build it
    const cur_path = try std.fs.selfExeDirPath(allocater);
    print("{}\n", .{cur_path});

    defer allocater.free(cur_path);

    var last_time: u64 = 0;

    while (true) {
        // collecting the files meta data
        const stat = try std.fs.cwd().statFile(cur_path);
        if (stat.mtime > last_time) {
            print("executable changed ", .{});
            last_time = stat.mtime;
            // in here we will create the code to do :
            // 1 - cancel the current process
            // 2 - start the process again just like nodemon
        }
    }
}
