shader_type spatial;

uniform sampler2D water_normal_noise;
uniform vec3 water_color : source_color;

uniform float wave_speed : hint_range(0.0, 50.0, 0.1) = 25.0;
uniform float time_scale : hint_range(0.0, 10.0, 0.25)= 1.0;


void fragment() {
	// Called for every pixel the material is visible on.
	
	
	vec2 _uv = UV;
	_uv.x += sin(TIME * time_scale + (_uv.x + _uv.y)*25.0)*0.01;
	_uv.y += cos(TIME * time_scale + (_uv.x - _uv.y)*25.0)*0.01;	//estos 2 deberian estar generando un efecto de olas
	
	ALBEDO = water_color; //color. se puede tocar en el material
	NORMAL_MAP = texture(water_normal_noise,UV).rgb; 
	NORMAL *= 0.5; //multiplica la normal para exagerarla un poco, para que sobresalga mas las olas
	ROUGHNESS = 0.2; // afecta el roughness, es lo que le da el brillo al agua
	
	ALPHA = 0.5;
}

