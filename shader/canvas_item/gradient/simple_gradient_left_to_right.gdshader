shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	COLOR = mix(color_a, color_b, UV.x);
}