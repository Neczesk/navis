extends Spatial

var wind_strength = 13.4
var wind_direction = Vector2(0.3, 0.7)

func _ready():
	$"main-ship".water_node = $test_ocean
	$"main-ship".wind_direction = wind_direction
	$"main-ship".wind_strength = wind_strength

var time: float = 0.0
#func _physics_process(delta):
#	for child in get_children():
#		if "water_level" in child:
#			var hpos = Vector2(child.global_transform.origin.x, child.global_transform.origin.z)
#			child.water_level = $ambient_ocean.get_height_at_point(hpos, time)
