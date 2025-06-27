// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function create_twentyfive_slice_data(sprite, corner_width, corner_height, sides_height, top_bot_width)
/// @description Creates a struct containing all 25 slices with their properties
/// @param {Asset.GMSprite} sprite The sprite to slice
/// @param {Real} corner_width The width of corner pieces
/// @param {Real} corner_height The height of corner pieces
/// @param {Real} sides_height The height of side pieces
/// @param {Real} top_bot_width The width of top/bottom pieces
/// @returns {Struct} A struct containing the slice data
function create_twentyfive_slice_data(sprite, corner_width, corner_height, sides_height, top_bot_width) {
    var spr_width = sprite_get_width(sprite);
    var spr_height = sprite_get_height(sprite);
    
    // Create the slice data struct
    var slice_data = {
        sprite: sprite,
        source_width: spr_width,
        source_height: spr_height,
        slices: array_create(25) // Will store all slice structs
    };
    
    // Fill the slices array with slice data
    for (var row = 0; row < 5; row++) {
        for (var col = 0; col < 5; col++) {
            var index = row * 5 + col;
            var slice_x = 0;
            var slice_y = 0;
            var slice_w = 0;
            var slice_h = 0;
            
            // Calculate x position and width based on column
            if (col == 0) {
                slice_x = 0;
                slice_w = corner_width;
            } else if (col == 1) {
                slice_x = corner_width;
                slice_w = (spr_width - (2 * corner_width) - top_bot_width) / 2;
            } else if (col == 2) {
                slice_x = corner_width + (spr_width - (2 * corner_width) - top_bot_width) / 2;
                slice_w = top_bot_width;
            } else if (col == 3) {
                slice_x = corner_width + (spr_width - (2 * corner_width) - top_bot_width) / 2 + top_bot_width;
                slice_w = (spr_width - (2 * corner_width) - top_bot_width) / 2;
            } else if (col == 4) {
                slice_x = spr_width - corner_width;
                slice_w = corner_width;
            }
            
            // Calculate y position and height based on row
            if (row == 0) {
                slice_y = 0;
                slice_h = corner_height;
            } else if (row == 1) {
                slice_y = corner_height;
                slice_h = (spr_height - (2 * corner_height) - sides_height) / 2;
            } else if (row == 2) {
                slice_y = corner_height + (spr_height - (2 * corner_height) - sides_height) / 2;
                slice_h = sides_height;
            } else if (row == 3) {
                slice_y = corner_height + (spr_height - (2 * corner_height) - sides_height) / 2 + sides_height;
                slice_h = (spr_height - (2 * corner_height) - sides_height) / 2;
            } else if (row == 4) {
                slice_y = spr_height - corner_height;
                slice_h = corner_height;
            }
            
            // Store slice data
            slice_data.slices[index] = {
                x: slice_x,
                y: slice_y,
                width: slice_w,
                height: slice_h,
                row: row,
                col: col,
                stretch_h: (col == 1 || col == 3), // Only columns 1 and 3 stretch horizontally
                stretch_v: (row == 1 || row == 3), // Only rows 1 and 3 stretch vertically
                center_h: (col == 2), // Column 2 centers horizontally
                center_v: (row == 2)  // Row 2 centers vertically
            };
        }
    }
    
    return slice_data;
}

/// @function draw_twentyfive_slice_ext(slice_data, dest_x, dest_y, dest_width, dest_height, corner_width, corner_height, sides_height, top_bot_width)
/// @description Draws a 25-slice sprite with the specified dimensions and slice properties
/// @param {Struct} slice_data The slice data struct created by create_twentyfive_slice_data
/// @param {Real} dest_x The x position to draw at
/// @param {Real} dest_y The y position to draw at
/// @param {Real} dest_width The total width to draw
/// @param {Real} dest_height The total height to draw
/// @param {Real} corner_width The width of corner pieces
/// @param {Real} corner_height The height of corner pieces
/// @param {Real} sides_height The height of left and right side pieces
/// @param {Real} top_bot_width The width of top/bottom pieces
function draw_twentyfive_slice_ext(slice_data, dest_x, dest_y, dest_width, dest_height, corner_width, corner_height, sides_height, top_bot_width) {
    // Calculate minimum dimensions that would keep non-stretchy parts intact
    var min_width = (2 * corner_width) + top_bot_width;
    var min_height = (2 * corner_height) + sides_height;
    
    // Clamp destination size to minimum dimensions
    dest_width = max(dest_width, min_width);
    dest_height = max(dest_height, min_height);
    
    // Calculate the remaining space for stretchy sections
    var stretch_width = (dest_width - (2 * corner_width) - top_bot_width) / 2; // Split remaining width between columns 1 and 3
    var stretch_height = (dest_height - (2 * corner_height) - sides_height) / 2; // Split remaining height between rows 1 and 3
    
    // Draw each slice based on its position and behavior
    for (var i = 0; i < array_length(slice_data.slices); i++) {
        var slice = slice_data.slices[i];
        var row = slice.row;
        var col = slice.col;
        
        // Calculate destination position and size for this slice
        var dx = dest_x;
        var dy = dest_y;
        var dw = slice.width;
        var dh = slice.height;
        
        // Calculate x position based on column behavior
        if (col == 0) {
            // Left edge - no stretch
            dx = dest_x;
            dw = corner_width;
        } else if (col == 1) {
            // First stretchy column
            dx = dest_x + corner_width;
            dw = stretch_width;
        } else if (col == 2) {
            // Center column - fixed width but centered
            dx = dest_x + corner_width + stretch_width;
            dw = top_bot_width; // Use top_bot_width for center column
        } else if (col == 3) {
            // Second stretchy column
            dx = dest_x + corner_width + stretch_width + top_bot_width;
            dw = stretch_width;
        } else if (col == 4) {
            // Right edge - no stretch
            dx = dest_x + dest_width - corner_width;
            dw = corner_width;
        }
        
        // Calculate y position based on row behavior
        if (row == 0) {
            // Top edge - no stretch
            dy = dest_y;
            dh = corner_height;
        } else if (row == 1) {
            // First stretchy row
            dy = dest_y + corner_height;
            dh = stretch_height;
        } else if (row == 2) {
            // Center row - fixed height but centered
            dy = dest_y + corner_height + stretch_height;
            dh = sides_height; // Use sides_height for center row
        } else if (row == 3) {
            // Second stretchy row
            dy = dest_y + corner_height + stretch_height + sides_height;
            dh = stretch_height;
        } else if (row == 4) {
            // Bottom edge - no stretch
            dy = dest_y + dest_height - corner_height;
            dh = corner_height;
        }
        
        // Draw the slice
        draw_sprite_part_ext(
            slice_data.sprite, 0,
            slice.x, slice.y,
            slice.width, slice.height,
            dx, dy,
            dw / slice.width,
            dh / slice.height,
            c_white, 1
        );
    }
}

/// @function scr_twentyfive_slice(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched)
/// @description Creates a 25-slice sprite surface for advanced UI scaling
/// @param {Asset.GMSprite} sprite The sprite to use for 25-slice scaling
/// @param {real} dest_x X position to draw the result
/// @param {real} dest_y Y position to draw the result  
/// @param {real} dest_width Total width of the scaled result
/// @param {real} dest_height Total height of the scaled result
/// @param {real} cornersWidth Width of all four corners
/// @param {real} cornersHeight Height of all four corners
/// @param {real} sidesHeight Height for left and right side segments
/// @param {real} topBotWidth Width for top and bottom middle segments
/// @param {bool} isStretched Whether middle segments are stretched (true) or tiled (false)
/// @returns {Id.Surface} Surface containing the 25-slice scaled sprite
function scr_twentyfive_slice(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched) {
    // Create surface for the result
    var surf = surface_create(dest_width, dest_height);
    surface_set_target(surf);
    draw_clear_alpha(c_white, 0);
    
    // Create slice data and draw using the new system
    var slice_data = create_twentyfive_slice_data(sprite, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
    draw_twentyfive_slice_ext(slice_data, 0, 0, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
    
    surface_reset_target();
    return surf;
}

/// @function scr_draw_twentyfive_slice(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched)
/// @description Draws a 25-slice sprite directly without creating a surface
/// @param {Asset.GMSprite} sprite The sprite to use for 25-slice scaling
/// @param {real} dest_x X position to draw at
/// @param {real} dest_y Y position to draw at
/// @param {real} dest_width Total width of the scaled result
/// @param {real} dest_height Total height of the scaled result
/// @param {real} cornersWidth Width of all four corners
/// @param {real} cornersHeight Height of all four corners
/// @param {real} sidesHeight Height for left and right side segments
/// @param {real} topBotWidth Width for top and bottom middle segments
/// @param {bool} isStretched Whether middle segments are stretched (true) or tiled (false)
function scr_draw_twentyfive_slice(sprite, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth, isStretched) {
    var slice_data = create_twentyfive_slice_data(sprite, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
    draw_twentyfive_slice_ext(slice_data, dest_x, dest_y, dest_width, dest_height, cornersWidth, cornersHeight, sidesHeight, topBotWidth);
}