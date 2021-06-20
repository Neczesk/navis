shader_type spatial;

render_mode world_vertex_coords;

uniform vec4 wave_0 = vec4(30.0, 10.0, 0.3, 0.7);
uniform vec4 wave_1 = vec4(10.0, 3.0, 0.5, 0.5);
uniform vec4 wave_2 = vec4(5.0, 1.2, 0.1, 0.9);
uniform float water_time = 0;

const float TAU = 6.2831853071;

float wave_iter(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0/wave_vec.x;
	float sp = sqrt(9.8 * (TAU/wave_vec.x));
	vec2 di = vec2(wave_vec.b, wave_vec.a);
	return wave_vec.y * sin(dot(di, hpos) * w + (time * sp));
}

float wave(vec2 hpos, float time){
	float output = 0.0;
	output += wave_iter(wave_0, hpos, time);
	output += wave_iter(wave_1, hpos, time);
	output += wave_iter(wave_2, hpos, time);
	return output;
}
//float wave(vec3 pos, float time, vec2 Di, float Wl, float Amp, float Sp){
//	Sp = Sp * 2.0/Wl;
//	float w = 2.0 / Wl;
//	float d1 = dot(pos.xz, Di);
//	float t1 = d1 * w;
//	float t2 = time * Sp;
//	float inner = t1 + t2;
//	return Amp * sin(inner);
//}
//
float partial_x(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0/wave_vec.x;
	float sp = sqrt(9.8 * (TAU/wave_vec.x));
	vec2 di = vec2(wave_vec.b, wave_vec.a);
	return w * di.x * wave_vec.y * cos(dot(di, hpos) * w + (time * sp));
}

float partial_y(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0/wave_vec.x;
	float sp = sqrt(9.8 * (TAU/wave_vec.x));
	vec2 di = vec2(wave_vec.b, wave_vec.a);
	return w * di.y * wave_vec.y * cos(dot(di, hpos) * w + (time * sp));
}

vec3 wave_normal_iter(vec4 wave_vec, vec2 hpos, float time){
	return vec3(-partial_x(wave_vec, hpos, time), 1.0, -partial_y(wave_vec, hpos, time));
}

vec3 wave_normal(vec2 hpos, float time){
	return wave_normal_iter(wave_0, hpos, time) + wave_normal_iter(wave_1, hpos, time) + wave_normal_iter(wave_2, hpos, time);
}
//vec3 wave_normal(vec3 pos, float time, vec2 Di, float Wl, float Amp, float Sp){
//	Sp = Sp * 2.0/Wl;
//	float w = 2.0/Wl;
//	float outer = w * Di.x * Amp;
//	float inner = dot(Di, pos.xz) * w + (time * Sp);
//	float partial_x = cos(inner) * outer;
//	outer = Wl * Di.y * Amp;
//	float partial_y = cos(inner) * outer;
//	return vec3(-partial_x, 1.0, -partial_y);
//
//}
//
//
void vertex(){
	VERTEX.y += wave(VERTEX.xz, water_time);
	NORMAL = wave_normal(VERTEX.xz, water_time);
}


void fragment(){

	RIM = 0.1;
//	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = vec3(0.1,0.2,0.3);
}
