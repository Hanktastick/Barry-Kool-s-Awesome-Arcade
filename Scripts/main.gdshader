shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float strength = 0.0;
uniform int samples = 8;
uniform vec2 center = vec2(0.5, 0.5); 

uniform vec4 tint_color : source_color = vec4(1.0, 0.5, 0.5, 1.0);
uniform float tint_strength = 0.5;

uniform float vignette_radius = 0.6;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float vignette_strength = 1.0;
uniform vec2 screen_size; 

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 color = vec4(0.0);

	for (int i = 0; i < samples; i++) {
		float t = float(i) / float(samples - 1);
		vec2 offset = (uv - center) * t * strength;
		color += texture(screen_texture, uv - offset);
	}



	
	color /= float(samples);

    // --- Circular vignette with aspect correction ---
    vec2 aspect = vec2(screen_size.x / screen_size.y, 1.0);
    vec2 dist = (uv - center) * aspect;
    float vignette = step(vignette_radius, length(dist));
    color.rgb = mix(color.rgb, color.rgb * (1.0 - vignette), vignette_strength);




// apply vignette

	
	color.rgb = mix(color.rgb, tint_color.rgb, tint_strength);
	
	COLOR = color;
}

