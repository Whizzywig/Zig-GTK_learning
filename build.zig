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
    
    //gtk import - can't find .lib files as they don't exist on windows
    //maybe test building on linux
    exe.linkLibC();

    if (b.args) |args| {
        //pass "windows" if building on windows
        if (args.next == "windows"){
            exe.linkSystemLibrary("comctl32");
            exe.linkSystemLibrary("gdi32");
            exe.linkSystemLibrary("gdiplus");
            //link the gtk stuff
            //This doesn't work because it is of tpye .typelib and zig can't link it
            exe.addLibraryPath(.{ .path = "C:/msys64/mingw64/lib/girepository-1.0"});
            exe.linkSystemLibrary("gtk4");
            exe.linkSystemLibrary("gdk4");
            exe.addLibraryPath(.{ .path = "C:/msys64/mingw64/lib"});
            exe.linkSystemLibrary("gobject-2.0");
            exe.linkSystemLibrary("gio-2.0");
            exe.linkSystemLibrary("pangoft2-1.0");
            exe.linkSystemLibrary("gdk_pixbuf-2.0");
            exe.linkSystemLibrary("pango-1.0");
            exe.linkSystemLibrary("cairo");
            exe.linkSystemLibrary("pangocairo-1.0");
            exe.linkSystemLibrary("freetype");
            exe.linkSystemLibrary("fontconfig");
            exe.linkSystemLibrary("gmodule-2.0");
            exe.linkSystemLibrary("gthread-2.0");
            exe.linkSystemLibrary("glib-2.0");

            exe.linkSystemLibrary("ffi");
            exe.linkSystemLibrary("gettextlib");
            exe.linkSystemLibrary("intl");

            //Find the include directory on windows
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/gtk-4.0"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/glib-2.0"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/lib/glib-2.0/include"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/cairo"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/pango-1.0"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/harfbuzz"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/gdk-pixbuf-2.0"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include/graphene-1.0"});
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/lib/graphene-1.0/include"});
            
            exe.addIncludePath(.{ .path = "C:/msys64/mingw64/include"});
        } else {
            //link for any other operating system
            exe.linkSystemLibrary("gtk4");
        }
    }
    
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
