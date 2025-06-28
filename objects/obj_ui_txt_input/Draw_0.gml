/// @description Insert description here
// You can write your code in this editor

draw_self();
draw_set_font(fnt_ui_large);
draw_set_color(c_black);


draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_ext(x + (sprite_width / 2),y + (sprite_height / 2), myval, 0, sprite_get_width(sprite_width));
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_font(-1);

