/// @description Insert description here
// You can write your code in this editor

/// @description 25-Slice Tool Initialization


layer_set_visible("ToolLayer", true);

// Image properties
loaded_sprite = -1;
sprite_width_val = 0;
sprite_height_val = 0;
image_x = 100;
image_y = 100;
image_scale = 1;

// Grid lines (in sprite coordinates)
corner_width = 32;
corner_height = 32;
sides_height = 64;
top_bot_width = 64;
handle_drag_pos_y = 0;
handle_drag_pos_x = 0;

// Initialize handle positions to match their red line positions
if (sprite_height_val > 0) handle_drag_pos_y = corner_height + sides_height;
if (sprite_width_val > 0) handle_drag_pos_x = corner_width + top_bot_width;

// Methods for adjusting dimensions
increment_amount = 1;

function adjust_corner_width(amount) {
    if (loaded_sprite == -1) return;
    var new_width = corner_width + amount;
    corner_width = floor(clamp(new_width, 1, sprite_width_val / 2 - 1));
    input_corner_width = string(corner_width);
    // Update handle position
    handle_drag_pos_x = corner_width + top_bot_width;
}

function adjust_corner_height(amount) {
    if (loaded_sprite == -1) return;
    var new_height = corner_height + amount;
    corner_height = floor(clamp(new_height, 1, sprite_height_val / 2 - 1));
    input_corner_height = string(corner_height);
    // Update handle position
    handle_drag_pos_y = corner_height + sides_height;
}

function adjust_top_bot_width(amount) {
    if (loaded_sprite == -1) return;
    var new_width = top_bot_width + amount;
    top_bot_width = floor(clamp(new_width, 1, sprite_width_val - (2 * corner_width) - 2));
    input_top_bot_width = string(top_bot_width);
    // Update handle position
    handle_drag_pos_x = corner_width + top_bot_width;
}

function adjust_sides_height(amount) {
    if (loaded_sprite == -1) return;
    var new_height = sides_height + amount;
    sides_height = floor(clamp(new_height, 1, sprite_height_val - (2 * corner_height) - 2));
    input_sides_height = string(sides_height);
    // Update handle position
    handle_drag_pos_y = corner_height + sides_height;
}

// UI State
dragging = false;
drag_target = "";
drag_offset_x = 0;
drag_offset_y = 0;

// Input boxes
input_corner_width = string(corner_width);
input_corner_height = string(corner_height);
input_sides_height = string(sides_height);
input_top_bot_width = string(top_bot_width);
input_active = "";

// UI Layout
ui_x = 500;
ui_y = 50;
input_width = 80;
input_height = 24;

// Generated code
generated_code = "";
show_code = false;

// File dialog flag
loading_file = false;

// Preview mode
preview_mode = false;
preview_width = 200;
preview_height = 150;
preview_x = 300;
preview_y = 200;
preview_debug_view = false;

// Camera and zoom - use existing viewport 0
camera = view_camera[0];
if (camera == -1) {
    camera = camera_create();
    view_camera[0] = camera;
}
camera_set_view_size(camera, room_width, room_height);
camera_set_view_pos(camera, 0, 0);
view_enabled = true;
view_visible[0] = true;

zoom_level = 1;
zoom_min = 0.1;
zoom_max = 5.0;
zoom_speed = 0.1;

// Camera position for panning
cam_x = 0;
cam_y = 0;
