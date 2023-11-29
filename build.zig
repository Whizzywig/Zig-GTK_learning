const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    var exe = b.addExecutable(.{
        .name = "GTK",
        .root_source_file = .{ .path = "src/main.zig"},
        .target = target,
        .optimize = optimize,
    });
    
    exe.linkLibC();

    //TODO: Find a way to tell people who build on windows that it won't work only cross compiling for windows could work
        
    //link for any other operating system
    exe.addLibraryPath(.{ .path = "/bin"});
    exe.addLibraryPath(.{ .path = "/usr/bin"});
    exe.addLibraryPath(.{ .path = "/usr/local/bin"});
    exe.addIncludePath(.{ .path = "/usr/include"});
    exe.linkSystemLibrary("gtk4");
    
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
