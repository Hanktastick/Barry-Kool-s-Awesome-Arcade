shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float pixel_size = 7.0;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_grid = screen_size / pixel_size;
	vec2 snapped_uv = floor(SCREEN_UV * pixel_grid) / pixel_grid;
	
	COLOR = texture(screen_texture, snapped_uv);
}