shader_type canvas_item;

uniform vec4 spawn_color: source_color = vec4(0.97, 0.68, 0.94, 1);
uniform float intensity = 1;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, spawn_color.rgb, intensity);
	COLOR = color;
}