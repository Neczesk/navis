extends RigidBody

# All airships should inherit this script
var wind_direction: Vector2
var wind_strength: float
export var sail_area: float 
export var rudder_power: float
export var bouyancy_delta: float = 5000
export var sail_delta: float = 1
var sail_level: float setget set_sail_level
func set_sail_level(new_sail):
	sail_level = clamp(new_sail, 0.0, 1.0)
	$sail_ship_1.set_sail_level(sail_level)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$sail_ship_1.set_sail_level(sail_level)
	$bouyancy_controller/bouyancy_point.max_bouyancy = weight*1.5
	$bouyancy_controller/bouyancy_point.min_bouyancy = weight*0.5
	$bouyancy_controller/bouyancy_point.bouyancy = weight 
	pass # Replace with function body.
	
func _integrate_forces(state):
	var bouyant_force = Vector3(0,0,0)
	for child in $bouyancy_controller.get_children():
		if "bouyant_force" in child:
			add_force(child.bouyant_force, global_transform.origin - child.global_transform.origin)
			
	var forward: Vector3 = transform.basis.z
	var wind3 = Vector3(wind_direction.x, 0, wind_direction.y)
	forward *= max(forward.dot(wind3)+1,0.2)
	forward *= (sail_level * sail_area * wind_strength)
	add_central_force(forward)
	
	if Input.is_action_pressed("steer_left"):
		add_torque(Vector3(0,1,0) * rudder_power * state.step)
	if Input.is_action_pressed("steer_right"):
		add_torque(Vector3(0,-1,0) * rudder_power * state.step)
	if Input.is_action_pressed("add_sail"):
		set_sail_level(sail_level+(sail_delta * state.step))
	if Input.is_action_pressed("remove_sail"):
		set_sail_level(sail_level-(sail_delta * state.step))
	if Input.is_action_pressed("lower_ballast"):
		$bouyancy_controller/bouyancy_point.bouyancy += bouyancy_delta * state.step
	if Input.is_action_pressed("raise_ballast"):
		$bouyancy_controller/bouyancy_point.bouyancy -= bouyancy_delta * state.step
			
	var current_lin_vel: Vector3 = state.linear_velocity
	var current_ang_vel: Vector3 = state.angular_velocity
	var lin_drag: Vector3 = current_lin_vel.normalized() * current_lin_vel.length_squared() * -1
	var ang_drag: Vector3 = current_ang_vel.normalized() * current_ang_vel.length_squared() * -1
	lin_drag *=  mass
	ang_drag *=  mass * mass
	
	add_central_force(lin_drag)
	add_torque(ang_drag)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
