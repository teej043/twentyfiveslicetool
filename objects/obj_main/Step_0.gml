/// @description Insert description here
// You can write your code in this editor

/// @description Tool Logic

// Handle zooming with mouse wheel
var scroll = mouse_wheel_down() - mouse_wheel_up(); // Inverted: wheel up = zoom in, wheel down = zoom out
if (scroll != 0) {
    var old_zoom = zoom_level;
    zoom_level = clamp(zoom_level + scroll * zoom_speed, zoom_min, zoom_max);
    
    // Zoom towards mouse position
    var mouse_world_x = cam_x + mouse_x * old_zoom;
    var mouse_world_y = cam_y + mouse_y * old_zoom;
    
    cam_x = mouse_world_x - mouse_x * zoom_level;
    cam_y = mouse_world_y - mouse_y * zoom_level;
    
    // Update camera
    camera_set_view_size(camera, room_width * zoom_level, room_height * zoom_level);
    camera_set_view_pos(camera, cam_x, cam_y);
}

// Handle panning with middle mouse or right mouse
if (mouse_check_button_pressed(mb_middle) || mouse_check_button_pressed(mb_right)) {
    drag_offset_x = mouse_x;
    drag_offset_y = mouse_y;
}
if (mouse_check_button(mb_middle) || mouse_check_button(mb_right)) {
    cam_x -= (mouse_x - drag_offset_x) * zoom_level;
    cam_y -= (mouse_y - drag_offset_y) * zoom_level;
    
    camera_set_view_pos(camera, cam_x, cam_y);
    
    // Update drag offset for next frame
    drag_offset_x = mouse_x;
    drag_offset_y = mouse_y;
}

// Convert mouse position to world coordinates for tool interaction
// Use GameMaker's built-in view mouse functions
var world_mouse_x = window_view_mouse_get_x(0);
var world_mouse_y = window_view_mouse_get_y(0);

// Handle file loading
if (keyboard_check_pressed(ord("L"))) {
    var file = get_open_filename("Image files|*.png;*.jpg;*.jpeg;*.bmp", "");
    if (file != "") {
        if (loaded_sprite != -1) sprite_delete(loaded_sprite);
        loaded_sprite = sprite_add(file, 0, false, false, 0, 0);
        if (loaded_sprite != -1) {
            sprite_width_val = sprite_get_width(loaded_sprite);
            sprite_height_val = sprite_get_height(loaded_sprite);
            
            // Position image in center of screen
            image_x = room_width / 2 - (sprite_width_val * image_scale) / 2;
            image_y = room_height / 2 - (sprite_height_val * image_scale) / 2;
            
            // Reset camera to show the image
            zoom_level = 1;
            cam_x = 0;
            cam_y = 0;
            camera_set_view_size(camera, room_width, room_height);
            camera_set_view_pos(camera, 0, 0);
            
            // Reset grid to reasonable defaults
            corner_width = min(32, sprite_width_val / 5);
            corner_height = min(32, sprite_height_val / 5);
            sides_height = min(64, sprite_height_val / 3);
            top_bot_width = min(64, sprite_width_val / 3);
            
            // Update input strings
            input_corner_width = string(corner_width);
            input_corner_height = string(corner_height);
            input_sides_height = string(sides_height);
            input_top_bot_width = string(top_bot_width);
        }
    }
}

// Handle input focus - use regular mouse coordinates for UI
if (mouse_check_button_pressed(mb_left)) {
    input_active = "";
    
    // Check if clicking on input boxes
    var input_y_start = ui_y + 30;
    if (mouse_x >= ui_x && mouse_x <= ui_x + input_width) {
        if (mouse_y >= input_y_start && mouse_y <= input_y_start + input_height) {
            input_active = "corner_width";
        } else if (mouse_y >= input_y_start + 35 && mouse_y <= input_y_start + 35 + input_height) {
            input_active = "corner_height";
        } else if (mouse_y >= input_y_start + 70 && mouse_y <= input_y_start + 70 + input_height) {
            input_active = "sides_height";
        } else if (mouse_y >= input_y_start + 105 && mouse_y <= input_y_start + 105 + input_height) {
            input_active = "top_bot_width";
        }
    }
}

// Handle text input
if (input_active != "") {
    var input_string = keyboard_string;
    if (input_string != "") {
        // Filter only numbers
        var filtered = "";
        for (var i = 1; i <= string_length(input_string); i++) {
            var char = string_char_at(input_string, i);
            if (string_digits(char) == char) {
                filtered += char;
            }
        }
        
        if (input_active == "corner_width") {
            input_corner_width = filtered;
            if (filtered != "") corner_width = real(filtered);
        } else if (input_active == "corner_height") {
            input_corner_height = filtered;
            if (filtered != "") corner_height = real(filtered);
        } else if (input_active == "sides_height") {
            input_sides_height = filtered;
            if (filtered != "") sides_height = real(filtered);
        } else if (input_active == "top_bot_width") {
            input_top_bot_width = filtered;
            if (filtered != "") top_bot_width = real(filtered);
        }
        
        keyboard_string = "";
    }
    
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape)) {
        input_active = "";
    }
}

// Handle preview resizing
if (preview_mode && loaded_sprite != -1) {
    var preview_handle_size = 8;
    
    // Check for preview resize handles (corners of preview)
    if (!dragging && mouse_check_button_pressed(mb_left)) {
        var mx = world_mouse_x;
        var my = world_mouse_y;
        
        // Bottom-right corner handle
        if (mx >= preview_x + preview_width - preview_handle_size && mx <= preview_x + preview_width + preview_handle_size &&
            my >= preview_y + preview_height - preview_handle_size && my <= preview_y + preview_height + preview_handle_size) {
            dragging = true;
            drag_target = "preview_resize";
        }
    }
    
    if (dragging && drag_target == "preview_resize" && mouse_check_button(mb_left)) {
        var mx = world_mouse_x;
        var my = world_mouse_y;
        
        preview_width = clamp(mx - preview_x, 50, 1000);
        preview_height = clamp(my - preview_y, 50, 1000);
    }
}

// Handle dragging on image - use world coordinates (only when not in preview mode)
if (loaded_sprite != -1 && !preview_mode) {
    var img_w = sprite_width_val * image_scale;
    var img_h = sprite_height_val * image_scale;
    
    if (!dragging && mouse_check_button_pressed(mb_left)) {
        // Check if clicking near grid lines - use world coordinates
        var mx = world_mouse_x - image_x;
        var my = world_mouse_y - image_y;
        
        if (mx >= 0 && mx <= img_w && my >= 0 && my <= img_h) {
            var grid_tolerance = 8; // Fixed tolerance in world space
            
            // Convert mouse to sprite coordinates
            var sprite_mx = mx / image_scale;
            var sprite_my = my / image_scale;
            
            // Check vertical lines (corner boundaries)
            if (abs(sprite_mx - corner_width) < grid_tolerance) {
                dragging = true;
                drag_target = "corner_width_left";
            } else if (abs(sprite_mx - (sprite_width_val - corner_width)) < grid_tolerance) {
                dragging = true;
                drag_target = "corner_width_right";
            }
            // Check vertical lines (middle section boundaries)
            else if (abs(sprite_mx - (corner_width + top_bot_width)) < grid_tolerance) {
                dragging = true;
                drag_target = "top_bot_width_left";
            } else if (abs(sprite_mx - (sprite_width_val - corner_width - top_bot_width)) < grid_tolerance) {
                dragging = true;
                drag_target = "top_bot_width_right";
            }
            
            // Check horizontal lines (corner boundaries)
            if (!dragging) {
                if (abs(sprite_my - corner_height) < grid_tolerance) {
                    dragging = true;
                    drag_target = "corner_height_top";
                } else if (abs(sprite_my - (sprite_height_val - corner_height)) < grid_tolerance) {
                    dragging = true;
                    drag_target = "corner_height_bottom";
                }
                // Check horizontal lines (middle section boundaries)
                else if (abs(sprite_my - (corner_height + sides_height)) < grid_tolerance) {
                    dragging = true;
                    drag_target = "sides_height_top";
                } else if (abs(sprite_my - (sprite_height_val - corner_height - sides_height)) < grid_tolerance) {
                    dragging = true;
                    drag_target = "sides_height_bottom";
                }
            }
        }
    }
    
    if (dragging && mouse_check_button(mb_left)) {
        var mx = world_mouse_x - image_x;
        var sprite_mx = mx / image_scale;
        var my = world_mouse_y - image_y;
        var sprite_my = my / image_scale;
        
        // Handle corner width dragging - keep middle sections in absolute positions
        if (drag_target == "corner_width_left") {
            var old_corner_width = corner_width;
            var new_corner_width = clamp(sprite_mx, 1, sprite_width_val / 2 - 1);
            var corner_change = new_corner_width - old_corner_width;
            
            // Adjust top_bot_width to keep middle sections in place
            top_bot_width = clamp(top_bot_width - corner_change, 1, sprite_width_val - (2 * new_corner_width) - 1);
            
            corner_width = new_corner_width;
            input_corner_width = string(round(corner_width));
            input_top_bot_width = string(round(top_bot_width));
        } else if (drag_target == "corner_width_right") {
            var old_corner_width = corner_width;
            var new_corner_width = clamp(sprite_width_val - sprite_mx, 1, sprite_width_val / 2 - 1);
            var corner_change = new_corner_width - old_corner_width;
            
            // Adjust top_bot_width to keep middle sections in place
            top_bot_width = clamp(top_bot_width - corner_change, 1, sprite_width_val - (2 * new_corner_width) - 1);
            
            corner_width = new_corner_width;
            input_corner_width = string(round(corner_width));
            input_top_bot_width = string(round(top_bot_width));
        }
        // Handle corner height dragging - keep middle sections in absolute positions
        else if (drag_target == "corner_height_top") {
            var old_corner_height = corner_height;
            var new_corner_height = clamp(sprite_my, 1, sprite_height_val / 2 - 1);
            var corner_change = new_corner_height - old_corner_height;
            
            // Adjust sides_height to keep middle sections in place
            sides_height = clamp(sides_height - corner_change, 1, sprite_height_val - (2 * new_corner_height) - 1);
            
            corner_height = new_corner_height;
            input_corner_height = string(round(corner_height));
            input_sides_height = string(round(sides_height));
        } else if (drag_target == "corner_height_bottom") {
            var old_corner_height = corner_height;
            var new_corner_height = clamp(sprite_height_val - sprite_my, 1, sprite_height_val / 2 - 1);
            var corner_change = new_corner_height - old_corner_height;
            
            // Adjust sides_height to keep middle sections in place
            sides_height = clamp(sides_height - corner_change, 1, sprite_height_val - (2 * new_corner_height) - 1);
            
            corner_height = new_corner_height;
            input_corner_height = string(round(corner_height));
            input_sides_height = string(round(sides_height));
        }
        // Handle top/bottom width dragging
        else if (drag_target == "top_bot_width_left" || drag_target == "top_bot_width_right") {
            // Just measure the distance between the handles
            var left_handle_x = corner_width;
            var right_handle_x = sprite_width_val - corner_width;
            var handle_distance = right_handle_x - left_handle_x;
            
            // Calculate how much of that distance should be the middle section
            top_bot_width = clamp(handle_distance - sprite_mx, 1, sprite_width_val - (2 * corner_width));
            input_top_bot_width = string(round(top_bot_width));
        }
        // Handle sides height dragging
        else if (drag_target == "sides_height_top" || drag_target == "sides_height_bottom") {
            // Just measure the distance between the handles
            var top_handle_y = corner_height;
            var bottom_handle_y = sprite_height_val - corner_height;
            var handle_distance = bottom_handle_y - top_handle_y;
            
            // Calculate how much of that distance should be the middle section
            sides_height = clamp(handle_distance - sprite_my, 1, sprite_height_val - (2 * corner_height));
            input_sides_height = string(round(sides_height));
        }
    }
    
    if (!mouse_check_button(mb_left)) {
        dragging = false;
        drag_target = "";
    }
}

// Generate code
if (keyboard_check_pressed(ord("G")) && loaded_sprite != -1) {
    generated_code = "scr_twentyfive_slice(sprite, x, y, width, height, " + 
                    string(round(corner_width)) + ", " + 
                    string(round(corner_height)) + ", " + 
                    string(round(sides_height)) + ", " + 
                    string(round(top_bot_width)) + ", true);";
    show_code = true;
    
    // Copy to clipboard
    clipboard_set_text(generated_code);
}

// Toggle code display
if (keyboard_check_pressed(ord("C"))) {
    show_code = !show_code;
}

// Toggle preview mode
if (keyboard_check_pressed(ord("T")) && loaded_sprite != -1) {
    preview_mode = !preview_mode;
    if (preview_mode) {
        // Set initial preview size close to original sprite size
        preview_width = sprite_width_val;
        preview_height = sprite_height_val;
        preview_x = image_x + sprite_width_val + 50;
        preview_y = image_y;
    }
}

// Reset view to center on image
if (keyboard_check_pressed(ord("R")) && loaded_sprite != -1) {
    // Position image in center of screen
    image_x = room_width / 2 - (sprite_width_val * image_scale) / 2;
    image_y = room_height / 2 - (sprite_height_val * image_scale) / 2;
    
    // Reset camera to show the image
    zoom_level = 1;
    cam_x = 0;
    cam_y = 0;
    camera_set_view_size(camera, room_width, room_height);
    camera_set_view_pos(camera, 0, 0);
}
