extends RigidBody

var water_level = 0
var displacement = 0
export var bouyancy = 10
export var sail_area = 100
export var rudder_power = 2000.0
var wind_strength: float
var wind_direction: Vector2

var sail_level = 0.0 setget set_sail_level
func set_sail_level(new_sail):
	sail_level = clamp(new_sail, 0.0, 1.0)
	$Plane.set("blend_shapes/Key 1", sail_level)

var water_node: Node setget set_water_node
var time_sync: float = 0

func set_water_node(new_water_node):
	water_node = new_water_node
	for probe in $CenterOfBouyancy.get_children():
		if "water_node" in probe:
			probe.water_node = water_node

func _ready():
	$Plane.set("blend_shapes/Key 1", sail_level)
	for probe in $CenterOfBouyancy.get_children():
		probe.bouyancy = bouyancy
	

var bouyant_force:float = 0.0
func _integrate_forces(state):
	if water_node and "water_time" in water_node:
		water_level = water_node.get_height_at_point(Vector2(global_transform.origin.x, global_transform.origin.z), water_node.water_time)
		displacement = global_transform.origin.y - water_level
		if displacement > 0: linear_damp = -1
		else: linear_damp = 2.0
		
	var bouyancy_probes = $CenterOfBouyancy.get_children()
	for probe in bouyancy_probes:
		var force = Vector3(0.0, probe.bouyant_force, 0.0)
		add_force(force/$CenterOfBouyancy.get_child_count(), probe.global_transform.origin - global_transform.origin)
		
	var forward: Vector3 = transform.basis.z
	var wind3 = Vector3(wind_direction.x, 0, wind_direction.y)

#	print(forward.dot(wind3))
	forward *= max(forward.dot(wind3)+1,0.2)
	forward *= (sail_level * sail_area * wind_strength)
#	print(forward.normalized())
#	print(forward)
#	print(Vector2(self.rotation.x, self.rotation.z).dot(wind_direction))
#	print(forward)
	
	add_central_force(forward)
	
	if Input.is_action_pressed("steer_left"):
		add_torque(Vector3(0,1,0) * rudder_power)
	if Input.is_action_pressed("steer_right"):
		add_torque(Vector3(0,-1,0) * rudder_power)
	if Input.is_action_pressed("add_sail"):
		set_sail_level(sail_level+0.01)
	if Input.is_action_pressed("remove_sail"):
		set_sail_level(sail_level-0.01)
	
	
	
	
	
	
	
#	time_sync += state.step
#	if water_node:
#		water_level = water_node.get_height_at_point(Vector2(global_transform.origin.x, global_transform.origin.z), time_sync)
#	displacement = global_transform.origin.y - water_level
#	if displacement < 0:
#		bouyant_force = -displacement * bouyancy
#		add_central_force(Vector3(0.0, bouyant_force, 0.0))
#	elif bouyant_force > 0:
#		bouyant_force = - bouyant_force
#		add_central_force(Vector3(0.0, bouyant_force, 0.0))
#		bouyant_force = 0
##	if linear_velocity.y > 0 and displacement > 0:
##		apply_central_impulse(Vector3(0.0, -linear_velocity.y, 0.0))
#
#
