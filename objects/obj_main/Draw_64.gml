/// @description Insert description here
// You can write your code in this editor

/// @description Draw UI Elements (Fixed on Screen)

// Draw instructions
draw_set_color(c_black);
draw_set_font(-1);
draw_text(10, 10, "25-Slice Tool");
draw_text(10, 30, "Press L to load image");
draw_text(10, 50, "Mouse wheel to zoom, Right/Middle click to pan");
draw_text(10, 70, "Press G to generate code (copies to clipboard)");
draw_text(10, 90, "Press C to toggle code display");
draw_text(10, 110, "Press R to reset view to center");
draw_text(10, 130, "Press T to toggle 25-slice preview");

// Draw zoom info
draw_text(10, 150, "Zoom: " + string(round(zoom_level * 100)) + "%");

// Draw side text info
draw_set_color(c_black);
draw_text(10, 180, "Sprite:");

    draw_text(80, 180, string(sprite_width_val) + "x" + string(sprite_height_val));


draw_text(10, 200, "Image pos:");
if (loaded_sprite != -1) {
    draw_text(100, 200, string(round(image_x)) + ", " + string(round(image_y)));
}

draw_text(10, 220, "Camera:");
if (loaded_sprite != -1) {
    draw_text(90, 220, string(round(cam_x)) + ", " + string(round(cam_y)));
}

// Draw preview mode info
if (preview_mode && loaded_sprite != -1) {
    draw_set_color(c_black);
    draw_text(10, 250, "PREVIEW MODE - Drag red handle to resize");
    draw_text(10, 270, "Preview size: " + string(round(preview_width)) + "x" + string(round(preview_height)));
}

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
