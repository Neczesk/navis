extends MeshInstance

onready var physics_texture: Texture = $physics_viewport.get_texture()
onready var physics_viewport: Viewport = $physics_viewport
onready var physics_material: ShaderMaterial = $physics_viewport/ColorRect.material
onready var surface_material: ShaderMaterial = self.get_active_material(0)
export(int,64,1024) var grid_size = 1024

var water_size:float = 512.0
var simulation_texture: Texture
var surface_data:PoolByteArray = PoolByteArray()

func save_heightmamp():
	var tex = $physics_viewport.get_texture()
	var img = tex.get_data()
	img.save_png("heightmap.png")


func _ready():
	physics_viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
	
	simulation_texture = physics_viewport.get_texture()
	
	surface_material.set_shader_param("displacement_map", simulation_texture)
	surface_material.set_shader_param("amp", 10.0)
	surface_material.set_shader_param("grid_points", $physics_viewport.size.x)
	set_waves(5, 3, Vector2(0.3, 0.7))
	
	
func _process(delta):
	update()
	surface_data = physics_texture.get_data().get_data()
	
func set_waves(med_amplitude: float, med_wavelength: float, med_direction: Vector2):
	var length_amp_ratio: float = med_amplitude/med_wavelength
	var waves = []
	#Set each wave as a Plane with x = wavelength, y = amplitude, z = direction.x, and d = direction.z
	var new_wave = Plane()
	new_wave.x = med_wavelength * rand_range(1.8,2.2)
	new_wave.y = new_wave.x * length_amp_ratio
	new_wave.z = med_direction.x
	new_wave.d = med_direction.y
	waves.append(new_wave)
	new_wave.x = med_wavelength * rand_range(1.2,1.7)
	new_wave.y = new_wave.x * length_amp_ratio
	var cur_direc = med_direction.rotated(rand_range(-PI/8, PI/8))
	new_wave.z = cur_direc.x
	new_wave.d = cur_direc.y
	waves.append(new_wave)
	new_wave.x = med_wavelength * rand_range(0.03,0.04)
	new_wave.y = new_wave.x * length_amp_ratio
	cur_direc = med_direction.rotated(rand_range(-PI/4, PI/4))
	new_wave.z = cur_direc.x
	new_wave.d = cur_direc.y
	waves.append(new_wave)
	new_wave.x = med_wavelength * rand_range(0.01,0.02)
	new_wave.y = new_wave.x * length_amp_ratio
	cur_direc = med_direction.rotated(rand_range(-PI/4, PI/4))
	new_wave.z = cur_direc.x
	new_wave.d = cur_direc.y
	waves.append(new_wave)
	new_wave.x = med_wavelength * rand_range(0.01,0.02)
	new_wave.y = new_wave.x * length_amp_ratio
	cur_direc = med_direction.rotated(rand_range(-PI/2, PI/2))
	new_wave.z = cur_direc.x
	new_wave.d = cur_direc.y
	waves.append(new_wave)
	new_wave.x = med_wavelength * rand_range(0.01,0.02)
	new_wave.y = new_wave.x * length_amp_ratio
	cur_direc = med_direction.rotated(rand_range(-PI/1, PI/1))
	new_wave.z = cur_direc.x
	new_wave.d = cur_direc.y
	waves.append(new_wave)
	for i in range(0,6):
		var param_string = "wave_" + String(i)
		physics_material.set_shader_param(param_string, waves[i])

	
	physics_material.set_shader_param("grid_size", float($physics_viewport.size.x))
	print(physics_material.get_shader_param("grid_size"))
	

	
#func update_displacement_map():
#	var img = simulation_texture.get_data()
#	physics_material.get_shader_param("displacement_map").set_data(img)

var lock = false
func update():
	if not lock:
		lock = true
#		surface_data = physics_texture.get_data().get_data()
		physics_viewport.render_target_update_mode = Viewport.UPDATE_ONCE
		
		yield(get_tree(), "idle_frame")
		lock = false

#func _initialize():
#	var img = Image.new()
#	img.create(grid_size, grid_size, false, Image.FORMAT_RGB8)
#	var tex = ImageTexture.new()
#	tex.create_from_image(img)
#	tex.flags = 0
	
	


func _on_Timer_timeout():
	save_heightmamp() # Replace with function body.
