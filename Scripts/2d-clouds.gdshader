shader_type canvas_item;

uniform float alpha_strength = 0.5;

void fragment() {
	vec2 scroll_speed = vec2(0.004, sin(TIME / 10.0) * 0.00025);
	vec2 uv = UV + scroll_speed * TIME;
	vec4 tex = texture(TEXTURE, uv);
	
	
	COLOR = vec4(tex.rgb, tex.a * alpha_strength);
}