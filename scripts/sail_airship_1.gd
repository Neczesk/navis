extends Spatial

var sail_level setget set_sail_level
func set_sail_level(new_sail):
	sail_level = clamp(new_sail, 0.0, 1.0)
	$Plane.set("blend_shapes/Key 1", sail_level)

func _ready():
	pass
