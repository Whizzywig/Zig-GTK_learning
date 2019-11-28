const Builder = @import("std").build.Builder;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const windows = b.option(bool, "windows", "create windows build") orelse false;
    var exe = b.addExecutable("GTK", "src/main.zig");
    exe.setBuildMode(mode);
    
    exe.addIncludeDir("C:/msys64/mingw64/include/gtk-3.0");
    exe.addIncludeDir("C:/msys64/mingw64/include/pango-1.0");
    exe.addIncludeDir("C:/msys64/mingw64/include/cairo");
    exe.addIncludeDir("C:/msys64/mingw64/include/gdk-pixbuf-2.0");
    exe.addIncludeDir("C:/msys64/mingw64/include/atk-1.0");
    exe.addIncludeDir("C:/msys64/mingw64/include/glib-2.0");
    exe.addIncludeDir("C:/msys64/mingw64/lib/glib-2.0/include");
    //exe.addIncludeDir("");    
    //if (windows) {
    //    exe.setTarget(builtin.Arch.x86_64, builtin.Os.windows, builtin.Abi.gnu);
    //}
    exe.addLibPath("C:/msys64/mingw64/lib");
    //gtk import - can't find .lib files as they don't exist on windows
    //maybe test building on linux
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("libgtk-3.dll");
    exe.linkSystemLibrary("libglib-2.0.dll");
    exe.linkSystemLibrary("gobject-2.0");

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
