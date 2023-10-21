shader_type canvas_item;

uniform vec3 color: source_color = vec3(1);
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
//	vec4 target_color = mix(curr_color, vec4(1, 1, 1, curr_color.a), 1.0);
	vec4 target_color = mix(curr_color, vec4(color, curr_color.a), progress);
	COLOR = target_color;
}