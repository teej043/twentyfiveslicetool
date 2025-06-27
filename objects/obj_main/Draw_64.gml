/// @description Insert description here
// You can write your code in this editor

/// @description Draw UI Elements (Fixed on Screen)



// Draw instructions
draw_set_color(c_black);
draw_set_font(-1);
draw_text(10, 10, "25-Slice Tool");
draw_text(10, 30, "Press L to load image");
draw_text(10, 50, "Drag grid lines or use text inputs");
draw_text(10, 70, "Blue handles = corners, Green handles = middle sections");
draw_text(10, 90, "Mouse wheel to zoom, Right/Middle click to pan");
draw_text(10, 110, "Press G to generate code (copies to clipboard)");
draw_text(10, 130, "Press C to toggle code display");
draw_text(10, 150, "Press R to reset view to center");
draw_text(10, 170, "Press T to toggle 25-slice preview");

// Draw zoom info
draw_text(10, 190, "Zoom: " + string(round(zoom_level * 100)) + "%");
draw_text(10, 210, "Mouse: " + string(mouse_x) + ", " + string(mouse_y));

// Convert mouse for debug using GameMaker's built-in functions
var debug_world_x = window_view_mouse_get_x(0);
var debug_world_y = window_view_mouse_get_y(0);
var debug_cam_x = camera_get_view_x(view_camera[0]);
var debug_cam_y = camera_get_view_y(view_camera[0]);

draw_text(10, 230, "View Mouse: " + string(round(debug_world_x)) + ", " + string(round(debug_world_y)));
draw_text(10, 250, "Camera: " + string(round(debug_cam_x)) + ", " + string(round(debug_cam_y)));

// Draw preview mode info
if (preview_mode && loaded_sprite != -1) {
    draw_set_color(c_black);
    draw_text(10, 270, "PREVIEW MODE - Drag red handle to resize");
    draw_text(10, 290, "Preview size: " + string(round(preview_width)) + "x" + string(round(preview_height)));
}

// Draw UI panel
draw_set_color(c_ltgray);
draw_rectangle(ui_x - 10, ui_y - 10, ui_x + 200, ui_y + 230, false);
draw_set_color(c_black);
draw_rectangle(ui_x - 10, ui_y - 10, ui_x + 200, ui_y + 230, true);

// Draw labels and input boxes
draw_set_color(c_black);
var input_y_start = ui_y + 30;

draw_text(ui_x, ui_y, "Grid Configuration:");

// Corner Width
draw_text(ui_x, input_y_start - 20, "Corner Width:");
draw_set_color(input_active == "corner_width" ? c_yellow : c_white);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, false);
draw_set_color(c_black);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, true);
draw_text(ui_x + 2, input_y_start + 2, input_corner_width);

// Corner Height
input_y_start += 35;
draw_text(ui_x, input_y_start - 20, "Corner Height:");
draw_set_color(input_active == "corner_height" ? c_yellow : c_white);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, false);
draw_set_color(c_black);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, true);
draw_text(ui_x + 2, input_y_start + 2, input_corner_height);

// Sides Height
input_y_start += 35;
draw_text(ui_x, input_y_start - 20, "Sides Height:");
draw_set_color(input_active == "sides_height" ? c_yellow : c_white);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, false);
draw_set_color(c_black);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, true);
draw_text(ui_x + 2, input_y_start + 2, input_sides_height);

// Top/Bot Width
input_y_start += 35;
draw_text(ui_x, input_y_start - 20, "Top/Bot Width:");
draw_set_color(input_active == "top_bot_width" ? c_yellow : c_white);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, false);
draw_set_color(c_black);
draw_rectangle(ui_x, input_y_start, ui_x + input_width, input_y_start + input_height, true);
draw_text(ui_x + 2, input_y_start + 2, input_top_bot_width);

// Draw generated code
if (show_code && generated_code != "") {
    draw_set_color(c_dkgray);
    draw_rectangle(10, display_get_gui_height() - 100, display_get_gui_width() - 10, display_get_gui_height() - 10, false);
    draw_set_color(c_black);
    draw_rectangle(10, display_get_gui_height() - 100, display_get_gui_width() - 10, display_get_gui_height() - 10, true);
    
    draw_set_color(c_white);
    draw_text(15, display_get_gui_height() - 95, "Generated Code (copied to clipboard):");
    draw_text(15, display_get_gui_height() - 75, generated_code);
}

// Draw current values info
if (loaded_sprite != -1) {
    draw_set_color(c_black);
    draw_text(ui_x, ui_y + 170, "Sprite: " + string(sprite_width_val) + "x" + string(sprite_height_val));
    draw_text(ui_x, ui_y + 185, "Image pos: " + string(round(image_x)) + ", " + string(round(image_y)));
    draw_text(ui_x, ui_y + 200, "Camera: " + string(round(cam_x)) + ", " + string(round(cam_y)));
} else {
    draw_set_color(c_black);
    draw_text(ui_x, ui_y + 170, "No sprite loaded - Press L");
}
