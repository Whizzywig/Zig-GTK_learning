const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("gtk/gtk.h");
});

pub fn print_hello(widget: *c.GtkWidget, data: c.gpointer) void{
    _ = data;
    _ = widget;
    c.g_print("Hello World\n");
}

fn activate(app: *c.GtkApplication, user_data: c.gpointer) callconv(.C) void{
    var window: *c.GtkWidget = undefined;
    var button: *c.GtkWidget = undefined;
    var button_box: *c.GtkWidget = undefined;

    window = c.gtk_application_window_new(app);
    //c.GTK_WINDOW not found
    c.gtk_window_set_title(@ptrCast(window), "Window");
    c.gtk_window_set_default_size(@ptrCast(window), 200, 200);

    button_box = c.gtk_box_new(c.GTK_ORIENTATION_VERTICAL, 0);
    c.gtk_widget_set_halign(button_box, c.GTK_ALIGN_CENTER);
    c.gtk_widget_set_valign(button_box, c.GTK_ALIGN_CENTER);
    c.gtk_window_set_child(@ptrCast(window), button_box);

    button = c.gtk_button_new_with_label("Hello World");
    var i = c.g_signal_connect_data(button, "clicked", @as(c.GCallback, @ptrCast(&print_hello)), null, null, c.G_CONNECT_AFTER);
    c.gtk_box_append(@ptrCast(button_box), button);

    c.gtk_widget_show(window);
    _ = i;
    _ = user_data;
}

pub fn main() void {
    //argc: c_int, argv: [*c][*c]u8
    var app: *c.GtkApplication = undefined;
    var status: c_int = 0;
    //any string begining with c makes it a c string
    const application_id = "org.gtk.example";
    app = c.gtk_application_new(application_id, c.G_APPLICATION_DEFAULT_FLAGS);
    //g_signal_connect is not in c figure it out
    //C.NULL causes errors
    //https://github.com/donpdonp/zootdeck/blob/master/src/gui/gtk.zig
    var x = c.g_signal_connect_data(app, "activate", @as(c.GCallback, @ptrCast(&activate)), null, null, c.G_CONNECT_AFTER);
    status = c.g_application_run(@ptrCast(app), 0, null);
    c.g_object_unref(app);
    _ = x;
    //return status;
}
