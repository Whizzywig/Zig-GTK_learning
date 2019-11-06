const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("GTK", "src/main.zig");
    exe.setBuildMode(mode);
    //gtk import
    //exe.addIncludeDir("C:/msys64/mingw64/include/gtk-3.0");
    //exe.addIncludeDir("C:/msys64/mingw64/include/c++/9.2.0");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("gtk+-3.0");
    exe.linkSystemLibrary("glib-2.0");
    exe.linkSystemLibrary("gobject-2.0");

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
