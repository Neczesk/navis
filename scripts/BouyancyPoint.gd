extends Spatial

var water_node: Node
var bouyancy: float
var displacement: float

func _ready():
	pass

var bouyant_force = 0.0
func _physics_process(delta):
	var water_level: float
	if water_node and "water_time" in water_node:
		water_level = water_node.get_height_at_point(Vector2(global_transform.origin.x, global_transform.origin.z), water_node.water_time)
		displacement = global_transform.origin.y - water_level
	if displacement < 0:
		bouyant_force = -displacement * bouyancy
	else:
		bouyant_force = -bouyancy * displacement
