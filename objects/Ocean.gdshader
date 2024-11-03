shader_type spatial;

uniform sampler2D water_normal_noise;
uniform vec3 water_color : source_color;

uniform float wave_speed : hint_range(0.0, 50.0, 0.1) = 25.0;
uniform float time_scale : hint_range(0.0, 10.0, 0.25)= 1.0;

uniform float uv_scale : hint_range(0.0, 10.0, 0.25) = 1.0;		//tocar esto para hacer que haya mas olas
uniform sampler2D screen_texture : hint_screen_texture,repeat_disable;

uniform float normal : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.25;
uniform float transparency : hint_range(0.0, 1.0, 0.1) = 0.5;
void fragment() {
	// Called for every pixel the material is visible on.
	
	
	vec2 _uv = UV*uv_scale;
	vec2 _suv = UV;
	
	_uv.x += sin(TIME * time_scale + (_uv.x + _uv.y)*wave_speed)*0.01;
	_uv.y += cos(TIME * time_scale + (_uv.x - _uv.y)*wave_speed)*0.01;	//estos 2 deberian estar generando un efecto de olas
	
	_suv.x += sin(TIME * time_scale + (_suv.x + _suv.y)*wave_speed)*0.01;
	_suv.y += cos(TIME * time_scale + (_suv.x - _suv.y)*wave_speed)*0.01;
	
	ALBEDO = texture(screen_texture,_suv).rgb*water_color; //color. se puede tocar en el material
	NORMAL_MAP = texture(water_normal_noise,_uv).rgb; 
	NORMAL *= normal; //multiplica la normal para exagerarla un poco, para que sobresalga mas las olas
	ROUGHNESS = roughness; // afecta el roughness, es lo que le da el brillo al agua
	
	ALPHA = transparency;
}

