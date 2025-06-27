/// @description Insert description here
// You can write your code in this editor

/// @description Draw Tool Interface

/// @description Draw World Elements (Sprite and Grid)

// Draw world background
draw_set_color(c_white);
draw_rectangle(0, 0, room_width, room_height, false);

/// @function draw_twentyfive_slice_custom(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched)
function draw_twentyfive_slice_custom(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched) {
    // Create slice data and draw using the new system
    var slice_data = create_twentyfive_slice_data(sprite, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
    draw_twentyfive_slice_ext(slice_data, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
}

// Draw loaded image
if (loaded_sprite != -1 && !preview_mode) {
    // Draw the sprite
    draw_sprite_ext(loaded_sprite, 0, image_x, image_y, image_scale, image_scale, 0, c_white, 1);
    
    var img_w = sprite_width_val * image_scale;
    var img_h = sprite_height_val * image_scale;
    
    // Draw grid lines
    draw_set_color(c_red);
    
    // Vertical lines
    var corner_left_x = image_x + corner_width * image_scale;
    var middle_left_x = image_x + (corner_width + top_bot_width) * image_scale;
    var middle_right_x = image_x + (sprite_width_val - corner_width - top_bot_width) * image_scale;
    var corner_right_x = image_x + (sprite_width_val - corner_width) * image_scale;
    
    draw_line(corner_left_x, image_y, corner_left_x, image_y + img_h);
    draw_line(middle_left_x, image_y, middle_left_x, image_y + img_h);
    draw_line(middle_right_x, image_y, middle_right_x, image_y + img_h);
    draw_line(corner_right_x, image_y, corner_right_x, image_y + img_h);
    
    // Horizontal lines
    var corner_top_y = image_y + corner_height * image_scale;
    var middle_top_y = image_y + (corner_height + sides_height) * image_scale;
    var middle_bottom_y = image_y + (sprite_height_val - corner_height - sides_height) * image_scale;
    var corner_bottom_y = image_y + (sprite_height_val - corner_height) * image_scale;
    
    draw_line(image_x, corner_top_y, image_x + img_w, corner_top_y);
    draw_line(image_x, middle_top_y, image_x + img_w, middle_top_y);
    draw_line(image_x, middle_bottom_y, image_x + img_w, middle_bottom_y);
    draw_line(image_x, corner_bottom_y, image_x + img_w, corner_bottom_y);
    
    // Draw grid line handles
    var handle_size = 4;
    
    // Corner handles (blue)
    draw_set_color(c_blue);
    draw_rectangle(corner_left_x - handle_size, image_y + img_h/2 - handle_size, 
                  corner_left_x + handle_size, image_y + img_h/2 + handle_size, false);
    
    draw_rectangle(corner_right_x - handle_size, image_y + img_h/2 - handle_size,
                  corner_right_x + handle_size, image_y + img_h/2 + handle_size, false);
    draw_rectangle(image_x + img_w/2 - handle_size, corner_top_y - handle_size, 
                  image_x + img_w/2 + handle_size, corner_top_y + handle_size, false);
    draw_rectangle(image_x + img_w/2 - handle_size, corner_bottom_y - handle_size, 
                  image_x + img_w/2 + handle_size, corner_bottom_y + handle_size, false);
    
    // Middle section handles (green)
    draw_set_color(c_green);
    
    // Single vertical green handle for top_bot_width
    draw_rectangle(middle_left_x - handle_size, image_y + img_h/2 - handle_size, 
                  middle_left_x + handle_size, image_y + img_h/2 + handle_size, false);
    
    // Single horizontal green handle for sides_height
    draw_rectangle(image_x + img_w/2 - handle_size, middle_top_y - handle_size, 
                  image_x + img_w/2 + handle_size, middle_top_y + handle_size, false);
}

// Draw preview mode
if (preview_mode && loaded_sprite != -1) {
    // Draw background for preview area
    draw_set_color(c_ltgray);
    draw_rectangle(preview_x, preview_y, preview_x + preview_width, preview_y + preview_height, false);
    
    // Draw 25-slice preview using our custom boundaries
    draw_twentyfive_slice_custom(loaded_sprite, preview_x, preview_y, preview_width, preview_height, 
                                corner_width, corner_height, sides_height, top_bot_width, true);
    
    // Draw grid lines over the preview to show slice boundaries
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    
    // Calculate stretchy section sizes
    var stretch_width = (preview_width - (2 * corner_width) - top_bot_width) / 2;
    var stretch_height = (preview_height - (2 * corner_height) - sides_height) / 2;
    
    // Calculate positions for vertical lines
    var x1 = preview_x + corner_width; // After left corners
    var x2 = preview_x + corner_width + stretch_width; // After first stretch column
    var x3 = preview_x + corner_width + stretch_width + top_bot_width; // After center column
    var x4 = preview_x + preview_width - corner_width; // Before right corners
    
    // Draw vertical lines
    draw_line_width(x1, preview_y, x1, preview_y + preview_height, 2);
    draw_line_width(x2, preview_y, x2, preview_y + preview_height, 2);
    draw_line_width(x3, preview_y, x3, preview_y + preview_height, 2);
    draw_line_width(x4, preview_y, x4, preview_y + preview_height, 2);
    
    // Calculate positions for horizontal lines
    var y1 = preview_y + corner_height; // After top corners
    var y2 = preview_y + corner_height + stretch_height; // After first stretch row
    var y3 = preview_y + corner_height + stretch_height + sides_height; // After center row
    var y4 = preview_y + preview_height - corner_height; // Before bottom corners
    
    // Draw horizontal lines
    draw_line_width(preview_x, y1, preview_x + preview_width, y1, 2);
    draw_line_width(preview_x, y2, preview_x + preview_width, y2, 2);
    draw_line_width(preview_x, y3, preview_x + preview_width, y3, 2);
    draw_line_width(preview_x, y4, preview_x + preview_width, y4, 2);
    
    // Add labels for each section
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var font_size = 10;
    draw_set_font(-1); // Use default font
    
    // Column labels at the top
    draw_text(preview_x + corner_width/2, preview_y - 10, "0\nNo Stretch");
    draw_text(preview_x + corner_width + stretch_width/2, preview_y - 10, "1\nStretch");
    draw_text(preview_x + corner_width + stretch_width + top_bot_width/2, preview_y - 10, "2\nFixed Width");
    draw_text(preview_x + corner_width + stretch_width + top_bot_width + stretch_width/2, preview_y - 10, "3\nStretch");
    draw_text(preview_x + preview_width - corner_width/2, preview_y - 10, "4\nNo Stretch");
    
    // Row labels on the left
    draw_set_halign(fa_right);
    draw_text(preview_x - 5, preview_y + corner_height/2, "0\nNo Stretch");
    draw_text(preview_x - 5, preview_y + corner_height + stretch_height/2, "1\nStretch");
    draw_text(preview_x - 5, preview_y + corner_height + stretch_height + sides_height/2, "2\nFixed Height");
    draw_text(preview_x - 5, preview_y + corner_height + stretch_height + sides_height + stretch_height/2, "3\nStretch");
    draw_text(preview_x - 5, preview_y + preview_height - corner_height/2, "4\nNo Stretch");
    
    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    
    // Debug info
    draw_set_color(c_black);
    var debug_y = preview_y + preview_height + 30;
    draw_text(preview_x, debug_y, "Parameters:");
    draw_text(preview_x, debug_y + 15, "corner_width: " + string(corner_width));
    draw_text(preview_x, debug_y + 30, "corner_height: " + string(corner_height)); 
    draw_text(preview_x, debug_y + 45, "sides_height: " + string(sides_height));
    draw_text(preview_x, debug_y + 60, "top_bot_width: " + string(top_bot_width));
    if (loaded_sprite != -1) {
        draw_text(preview_x, debug_y + 75, "Sprite size: " + string(sprite_get_width(loaded_sprite)) + " x " + string(sprite_get_height(loaded_sprite)));
    }
    
    // Draw preview border
    draw_set_color(c_black);
    draw_rectangle(preview_x - 2, preview_y - 2, preview_x + preview_width + 2, preview_y + preview_height + 2, true);
    
    // Draw resize handle
    var handle_size = 8;
    draw_set_color(c_red);
    draw_rectangle(preview_x + preview_width - handle_size, preview_y + preview_height - handle_size, 
                  preview_x + preview_width + handle_size, preview_y + preview_height + handle_size, false);
    draw_set_color(c_white);
    draw_rectangle(preview_x + preview_width - handle_size + 2, preview_y + preview_height - handle_size + 2, 
                  preview_x + preview_width + handle_size - 2, preview_y + preview_height + handle_size - 2, false);
    
    // Draw original sprite for comparison (faded)
    draw_set_alpha(0.3);
    draw_sprite_ext(loaded_sprite, 0, image_x, image_y, image_scale, image_scale, 0, c_white, 1);
    draw_set_alpha(1);
    
    // Add label
    draw_set_color(c_black);
    draw_text(preview_x, preview_y - 40, "25-Slice Preview (Red lines show slice boundaries):");
}
