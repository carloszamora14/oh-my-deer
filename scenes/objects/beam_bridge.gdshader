shader_type canvas_item;

void fragment() {
	float epsilon = 0.15;
	vec4 curr_color = texture(TEXTURE, UV);
	if (1.00 - curr_color.r <= epsilon && 1.00 - curr_color.g <= epsilon && 1.00 - curr_color.b <= epsilon) {
		COLOR = vec4(0, 0, 0, 0);
	}
}
