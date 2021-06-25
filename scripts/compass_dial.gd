
tool
extends Spatial

export var heading: float = 0 setget set_heading
export var wind_direction: float = 0 setget set_wind_direction

func set_wind_direction(new_direction):
	wind_direction = new_direction
	$wind_pivot.rotation_degrees.y = -wind_direction + -heading

func set_heading(heading_vector):
	if heading_vector is Vector2:
		heading = heading_vector.dot(-Vector2.AXIS_Y)
	else:
		heading = heading_vector
	$dial.rotation_degrees = Vector3(0,-heading,0)
	$wind_pivot.rotation_degrees.y = -wind_direction + -heading



func _ready():
	pass
