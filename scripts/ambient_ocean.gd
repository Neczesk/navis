extends MeshInstance

var Q: float
var wave_0: Plane = Plane(30.0, 7.5, 0.6679, -0.365937)
var wave_1: Plane = Plane(3.759308, 0.225558, -0.242432, 0.72196)
#uniform vec4 wave_0 = vec4(30.0, 7.5, 0.6679, -0.365937);
#uniform vec4 wave_1 = vec4(3.759308, 0.225558, -0.242432, 0.72196);


func _ready():
	get_active_material(0).set_shader_param("Q", Q)
	get_active_material(0).set_shader_param("wave_0", wave_0)
	get_active_material(0).set_shader_param("wave_1", wave_1)

func get_height_at_point(hpos: Vector2, time:float):
	return wave(hpos, time).y
	

	

func wavex(hpos: Vector2, time: float, Di: Vector2, w: float, Amp: float, Sp: float, Qi: float) -> float:
	var cosineTerm: float = hpos.dot(Di * w) + (Sp * time)
	return (Qi * Amp) * Di.x * cos(cosineTerm)
#float wavex(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
#	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
#	return (Qi*Amp) * Di.x * cos(cosineTerm);
#}
#
func wavez(hpos: Vector2, time: float, Di: Vector2, w: float, Amp: float, Sp: float, Qi: float) -> float:
	var cosineTerm = hpos.dot(Di * w) + (Sp * time)
	return (Qi * Amp) * Di.y * cos(cosineTerm)
#float wavez(vec2 hpos, float time, vec2 Di, float w, float Amp, float Sp, float Qi){
#	float cosineTerm = dot((w*Di), hpos.xy) + (Sp * time);
#	return (Qi*Amp) * Di.y * cos(cosineTerm);
#}
#
func wave_height(wave_vec: Plane, time: float, hpos: Vector2, sp: float) -> float:
	var w: float = 2.0 / wave_vec.x
	return wave_vec.y * sin((w * Vector2(wave_vec.z, wave_vec.d)).dot(hpos) + (sp * time))
#float wave_height(vec4 wave_vec, float time, vec2 hpos){
#	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
#	float w = 2.0 / wave_vec[0];
#	return wave_vec[1] * sin(dot(w*vec2(wave_vec[2], wave_vec[3]), hpos) + (speed*time));
#
#}
func wave_iter(wave_vec: Plane, time: float, hpos: Vector2):
	var speed: float = sqrt(9.8 * (TAU/wave_vec.x))
	var w: float = 2.0 / wave_vec.x
	var Qi = Q / (w * wave_vec.y * 2.0)
	var Di = Vector2(wave_vec.z, wave_vec.d)
	var x = wavex(hpos, time, Di, w, wave_vec.y, speed, Qi)
	var z = wavez(hpos, time, Di, w, wave_vec.y, speed, Qi)
	var y = wave_height(wave_vec, time, hpos, speed)
	return Vector3(x,y,z)
#vec3 wave_iter(vec4 wave_vec, float time, vec2 hpos){
#	float speed = sqrt(9.8 * twoPI/wave_vec[0]);
#	float w = 2.0 / wave_vec[0];
#	//float Qi = Q / (w * wave_vec[1] * 15.0);
#	float Qi = Q;
#	vec2 Di = vec2(wave_vec[2], wave_vec[3]);
#	float x = wavex(hpos, time, Di, w, wave_vec[1], speed, Qi);
#	float z = wavez(hpos, time, Di, w, wave_vec[1], speed, Qi);
#	float y = wave_height(wave_vec, time, hpos);
#	return vec3(x,y,z);
#
#}
func wave(hpos: Vector2, time: float):
	var output: Vector3 = Vector3(0,0,0)
	var t = time
	output += wave_iter(wave_0, t, hpos)
	output += wave_iter(wave_1, t, hpos)
	output.x += hpos.x
	output.z += hpos.y
	return output
#vec3 wave(vec3 pos, float time){
#	vec3 waves[2] = vec3[2];
#	waves[0] = wave_iter(wave_0, time, pos.xz);
#	waves[1] = wave_iter(wave_1, time, pos.xz);
#	vec3 output = vec3(0.0,0.0,0.0);
#	for (int i = 0; i < 2; i++){
#		output += waves[i];
#	}
#	output[0] += pos.x;
#	output[2] += pos.z;
#	return output;
#}
