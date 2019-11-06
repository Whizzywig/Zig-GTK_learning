const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("gtk/gtk.h");
});

pub fn print_hello(widget: *c.GtkWidget, data: c.gpointer) void{
    c.g_print(c"Hello World\n");
}

fn activate(app: *c.GtkApplication, user_data: c.gpointer) void{
    var window: *c.GtkWidget = undefined;
    var button: *c.GtkWidget = undefined;
    var button_box: *c.GtkWidget = undefined;

    window = c.gtk_application_window_new(app);
    //c.GTK_WINDOW not found
    c.gtk_window_set_title(@ptrCast([*c]c.GtkWindow, window), c"Window");
    c.gtk_window_set_default_size(@ptrCast([*c]c.GtkWindow, window), 200, 200);

    button_box = c.gtk_button_box_new(c.GtkOrientation.GTK_ORIENTATION_HORIZONTAL);
    c.gtk_container_add(@ptrCast([*c]c.GtkContainer, window), button_box);

    button = c.gtk_button_new_with_label(c"Hello World");
    var i = c.g_signal_connect_data(button, c"clicked", @ptrCast(c.GCallback, print_hello), null, null, c.GConnectFlags.G_CONNECT_AFTER);
    c.gtk_container_add(@ptrCast([*c]c.GtkContainer, button_box), button);

    c.gtk_widget_show_all(window);
}

pub fn main() void {
    //argc: c_int, argv: [*c][*c]u8
    var app: *c.GtkApplication = undefined;
    var status: c_int = 0;
    //any string begining with c makes it a c string
    const application_id = c"org.gtk.example";
    app = c.gtk_application_new(application_id, c.GApplicationFlags.G_APPLICATION_FLAGS_NONE);
    //g_signal_connect is not in c figure it out
    //C.NULL causes errors
    //https://github.com/donpdonp/zootdeck/blob/master/src/gui/gtk.zig
    var x = c.g_signal_connect_data(app, c"activate", @ptrCast(c.GCallback, activate), null, null, c.GConnectFlags.G_CONNECT_AFTER);
    status = c.g_application_run(@ptrCast([*c]c.GApplication,app), 0, null);
    c.g_object_unref(app);

    //return status;
}
