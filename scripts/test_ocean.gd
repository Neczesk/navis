extends MeshInstance

var wind_direction: Vector2 setget set_wind_direction
var wind_strength: float setget set_wind_strength
var _median_wave_height: float
var _median_wavelength: float
func set_wind_direction(new_direction: Vector2):
	wind_direction = new_direction
	generate_waves()
	
func set_wind_strength(new_strength: float):
	wind_strength = new_strength
	_median_wave_height = pow(wind_strength, 2) * 0.0015
	_median_wavelength = pow(wind_strength, 2) * 0.025
	generate_waves()

var wave_0: Plane = Plane(5.0, 1.0, 0.3, 0.7)
var wave_1: Plane = Plane(1.0, 0.30, 0.5, 0.5)
var wave_2: Plane = Plane(0.1, 0.06, 0.1, 0.9)
var water_time: float = 0 setget set_water_time

func generate_waves():
	var median_ratio = _median_wave_height / _median_wavelength
	var cur_length = _median_wavelength * rand_range(0.9, 1.2)
	wave_0 = Plane(cur_length, median_ratio * cur_length, wind_direction.x, wind_direction.y)
	cur_length = _median_wavelength * rand_range(0.4, 0.7)
	var cur_direction = wind_direction.rotated(rand_range(-PI/4, PI/4))
	wave_1 = Plane(cur_length, median_ratio * cur_length, cur_direction.x, cur_direction.y)
	cur_length = _median_wavelength * rand_range(0.1, 0.3)
	cur_direction = wind_direction.rotated(rand_range(-PI/2, PI/2))
	wave_2 = Plane(cur_length, median_ratio * cur_length, cur_direction.x, cur_direction.y)
	get_active_material(0).set_shader_param("wave_0", wave_0)
	get_active_material(0).set_shader_param("wave_1", wave_1)
	get_active_material(0).set_shader_param("wave_2", wave_2)

func set_water_time(new_time):
	water_time = new_time
	get_active_material(0).set_shader_param("water_time", water_time)
func _ready():
	get_active_material(0).set_shader_param("wave_0", wave_0)
	get_active_material(0).set_shader_param("wave_1", wave_1)
	get_active_material(0).set_shader_param("wave_2", wave_2)


func _process(delta):
	set_water_time(water_time + delta)

func get_height_at_point(hpos: Vector2, time: float) -> float:
	return wave_height(hpos, water_time)

func wave_iter(wave_vec: Plane, hpos: Vector2, time: float) -> float:
	var w = 2.0/wave_vec.x
	var sp = sqrt(9.8 * (TAU/wave_vec.x))
	var di = Vector2(wave_vec.z, wave_vec.d)
	return wave_vec.y * sin(di.dot(hpos) * w + (time * sp))
	
func wave_height(hpos: Vector2, time: float) -> float:
	var output = 0.0
	output += wave_iter(wave_0, hpos, time)
	output += wave_iter(wave_1, hpos, time)
	output += wave_iter(wave_2, hpos, time)
	return output
