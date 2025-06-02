const std = @import("std");
const print = std.debug.print;

pub fn watchFiles() !void {
    const allocater = std.heap.page_allocator;
    // getting the current path for the application and then tests how to build it
    // const cur_path = try std.fs.selfExeDirPathAlloc(allocater);
    const path = "C:\\Users\\yousuf\\Documents\\zigmon";
    const cur_path = try std.fs.path.join(allocater, &.{ path,""});
    print("just starting the watch files \n", .{});
    print("the current path is {s}\n", .{cur_path});
    defer allocater.free(cur_path);

    // open the directory
    var dir = try std.fs.openDirAbsolute(cur_path, .{.iterate = true});
    defer dir.close();

    var file_count:usize = 0;
    var file_mtime:[100]i128 = undefined;
    // var ignor:[2]u8 =.{".git",".vscode"};

    while (true) {
        // Create an iterator for the directory entries
        var iterator = dir.iterate();
        while (try iterator.next()) |entry| {
            if(entry.kind != .file) continue;
            // joining the filepath for all the files inside the directory
            const full_path = try std.fs.path.join(allocater, &.{ cur_path, entry.name });
            defer allocater.free(full_path);            
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
        file_count =0;
        
    }
}



pub fn main() !void {
    try watchFiles();
}

