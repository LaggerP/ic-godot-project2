shader_type spatial;

uniform sampler2D tex;
uniform sampler2D noise_tex1;
uniform sampler2D noise_tex2;
uniform float distortion_factor;
uniform float distortion_speed;

varying vec2 noise_uv2;
varying vec2 noise_uv;

void vertex() {
	noise_uv = UV + TIME * distortion_speed;
	noise_uv2 = UV - TIME * distortion_speed + vec2(0.2, 0.5);
}

void fragment() {

	
	vec2 noise = vec2(texture(noise_tex1, noise_uv).r, texture(noise_tex2, noise_uv).r);
	vec2 noise2 = vec2(texture(noise_tex1, noise_uv2).r, texture(noise_tex2, noise_uv2).r);
	
	vec2 base_uv = UV + (noise+noise2) * distortion_factor;
	
	
	ALBEDO = texture(tex, base_uv).rgb;
	// Called for every pixel the material is visible on.
}

