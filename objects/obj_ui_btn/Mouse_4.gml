/// @description Insert description here
// You can write your code in this editor

switch(tool_index) {
	case 0: 
		if (is_up == true) {
			obj_main.adjust_corner_width(1);
		} else {
			obj_main.adjust_corner_width(-1);
		}
		break;
	case 1: 
		if (is_up == true) {
			obj_main.adjust_corner_height(1);
		} else {
			obj_main.adjust_corner_height(-1);
		}
		break;
	case 2: 
		if (is_up == true) {
			obj_main.adjust_sides_height(1);
		} else {
			obj_main.adjust_sides_height(-1);
		}
		break;
	case 3: 
		if (is_up == true) {
			obj_main.adjust_top_bot_width(1);
		} else {
			obj_main.adjust_top_bot_width(-1);
		}
		break;
}
