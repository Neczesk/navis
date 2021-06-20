shader_type spatial;
render_mode specular_toon;

uniform float Q = 0.2;
//uniform int num_waves = 15;

//each wave gets an array
//In order: wavelength, amplitude, direction.x, direction.y
uniform vec4 wave_0 = vec4(30.0, 7.5, 0.6679, -0.365937);
uniform vec4 wave_1 = vec4(3.759308, 0.225558, -0.242432, 0.72196);
//uniform vec4 wave_2 = vec4(5.263312, 0.315799, -0.701566, 0.296319);
//uniform vec4 wave_3 = vec4(4.918343, 0.295101, 0.691606, -0.318875);
//uniform vec4 wave_4 = vec4(4.722698, 0.283362, 0.740368, -0.17848);
//uniform vec4 wave_5 = vec4(2.231143, 0.133869, -0.08292, -0.75705);
//uniform vec4 wave_6 = vec4(2.491879, 0.149513, -0.601034, 0.467716);
//uniform vec4 wave_7 = vec4(2.380039, 0.142802, 0.512172, 0.563631);
//uniform vec4 wave_8 = vec4(2.341395, 0.140484, 0.726642, 0.228015);
//uniform vec4 wave_9 = vec4(2.136036, 0.128162, -0.747891, 0.143732);
//uniform vec4 wave_10 = vec4(0.383914, 0.023035, 0.740611, 0.177469);
//uniform vec4 wave_11 = vec4(0.449218, 0.026953, 0.228728, -0.726418);
//uniform vec4 wave_12 = vec4(0.44972, 0.026983, -0.652778, 0.392277);
//uniform vec4 wave_13 = vec4(0.472002, 0.02832, 0.050137, 0.759925);
//uniform vec4 wave_14 = vec4(0.462938, 0.027776, -0.56865, 0.506594);

const float PI = 3.14159265358979323846;
const float twoPI = PI*2.0;


float wavex(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
	return (Qi*Amp) * Di.x * cos(cosineTerm);
}

float wavez(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
	return (Qi*Amp) * Di.y * cos(cosineTerm);
}

float wave_height(vec4 wave_vec, float time, vec2 hpos){
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	float w = 2.0 / wave_vec[0];
	return wave_vec[1] * sin(dot(w*vec2(wave_vec[2], wave_vec[3]), hpos) + (speed*time));

}

vec3 wave_iter(vec4 wave_vec, float time, vec2 hpos){
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	float w = 2.0 / wave_vec[0];
	//float Qi = Q / (w * wave_vec[1] * 15.0);
	float Qi = Q;
	vec2 Di = vec2(wave_vec[2], wave_vec[3]);
	float x = wavex(hpos, time, Di, w, wave_vec[1], speed, Qi);
	float z = wavez(hpos, time, Di, w, wave_vec[1], speed, Qi);
	float y = wave_height(wave_vec, time, hpos);
	return vec3(x,y,z);

}

vec3 wave(vec3 pos, float time){
	vec3 waves[2] = vec3[2];
	waves[0] = wave_iter(wave_0, time, pos.xz);
	waves[1] = wave_iter(wave_1, time, pos.xz);
	vec3 output = vec3(0.0,0.0,0.0);
	for (int i = 0; i < 2; i++){
		output += waves[i];
	}
	output[0] += pos.x;
	output[2] += pos.z;
	return output;
}

float normal_sine(float w, vec2 Di, vec2 hpos, float Sp, float time){
	return sin(w * dot(Di, hpos) + (Sp * time));
}

float normal_cos(float w, vec2 Di, vec2 hpos, float Sp, float time){
	return cos(w * dot(Di, hpos) + (Sp * time));
}

vec3 wave_normal_iter(vec4 wave_vec, vec2 hpos, float time){
	float w = 2.0 / wave_vec[0];
	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
	vec2 Di = vec2(wave_vec[2], wave_vec[3]);
	//float Qi = Q / (w * wave_vec[1] * 15.0);
	float Qi = Q;
	float x = wave_vec[2] * (w * wave_vec[1]) * normal_cos(w,Di, hpos, speed, time);
	float z = wave_vec[3] * (w * wave_vec[1]) * normal_cos(w, Di, hpos, speed, time);
	float height = Qi * (w* wave_vec[1]) * normal_sine(w, Di, hpos, speed, time);
	return vec3(x, height, z);
}

vec3 wave_normal(vec3 pos, float time){
	vec3 waves[2] = vec3[2];
	waves[0] = wave_normal_iter(wave_0, pos.xz, time);
	waves[1] = wave_normal_iter(wave_1, pos.xz, time);

	vec3 output = vec3(0.0,0.0,0.0);
	for (int i = 0; i < 2; i++){
		output += waves[i];
	}
	output[0] *= -1.0;
	output[1] = 1.0 - output[1];
	output[2] *= -1.0;
	return output;
	
}


void vertex(){
	VERTEX += wave((WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz, TIME);
	NORMAL = wave_normal((WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz, TIME);
}


void fragment(){
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.1;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.1,0.2,0.3) + (0.1 * fresnel);
}
