shader_type canvas_item;

uniform vec4 wave_0;
uniform vec4 wave_1;
uniform vec4 wave_2;
uniform vec4 wave_3;
uniform vec4 wave_4;
uniform vec4 wave_5;

uniform float grid_size;

const float PI = 3.14;

float wave_iter(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0 / wave_vec.x;
	float sp = sqrt(9.8 * (2.0*PI)/wave_vec.x);
	vec2 di = vec2(wave_vec.z, wave_vec.a);
	return wave_vec.y * sin(dot(di, hpos) * w + (time * sp));
}

float height(vec2 hpos, float time){
	float height = 0.0;
	height += wave_iter(wave_0, hpos, time);
	height += wave_iter(wave_1, hpos, time);
	height += wave_iter(wave_2, hpos, time);
	height += wave_iter(wave_3, hpos, time);
	height += wave_iter(wave_4, hpos, time);
	height += wave_iter(wave_5, hpos, time);
	return height;
}

void fragment(){
	float result = height(UV * grid_size, TIME);
	result /= 100.0;
	if (result >= 0.0){
		COLOR.r = result;
		COLOR.g = 0.0;
	} else{
		COLOR.g = -result;
		COLOR.r = 0.0;
	}
//	COLOR = vec4(0.0,0.0,0.0,1.0);
//	COLOR = vec4(normalize(wave_1).rgb, 1.0);
}