const std = @import("std");
const print = std.debug.print;

var start_timestamp: i64 = undefined;

pub fn signal_handler(_: c_int) callconv(.C) void {
    const total_time = std.time.milliTimestamp() - start_timestamp;
    const seconds: f32 = @intToFloat(f32, total_time) / 1000;
    print("\ndone in {d:.3} seconds\n", .{seconds});
    std.process.exit(0);
}

pub fn main() noreturn {
    start_timestamp = std.time.milliTimestamp();
    // setup signal handler
    const act = std.os.Sigaction{
        .handler = .{ .handler = signal_handler },
        .mask = std.os.empty_sigset,
        .flags = 0,
    };
    std.os.sigaction(std.os.SIG.INT, &act, null) catch unreachable;

    print("stopwatch started\n", .{});
    while (true) {}
    unreachable;
}
