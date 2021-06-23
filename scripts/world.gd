extends Spatial

export var wind_strength = 13.4
export var wind_direction = Vector2(0.3, 0.7)

func set_wind(strength, direction):
	wind_strength = strength
	wind_direction = direction
	for child in get_children():
		if "wind_strength" in child:
			child.wind_strength = wind_strength
		if "wind_direction" in child:
			child.wind_direction = wind_direction

func _ready():

	set_wind(10, Vector2(0.3, 0.7))

var time: float = 0.0
#func _physics_process(delta):
#	for child in get_children():
#		if "water_level" in child:
#			var hpos = Vector2(child.global_transform.origin.x, child.global_transform.origin.z)
#			child.water_level = $ambient_ocean.get_height_at_point(hpos, time)
