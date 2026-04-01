shader_type canvas_item;

uniform float alpha_strength = 1;

void fragment() {
	vec2 scroll_speed = vec2(0.02, 0.04);
	vec2 uv = UV + scroll_speed * TIME;
	vec4 tex = texture(TEXTURE, uv);
	
	
	COLOR = vec4(tex.rgb, tex.a * alpha_strength);
}