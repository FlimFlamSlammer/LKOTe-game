shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 shift;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = textureLod(screen_texture, vec2(SCREEN_UV.x + shift.x * 0.001724138, SCREEN_UV.y + shift.y * 0.002777778), 0.0).rgb;
	COLOR = vec4(color, 1);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
