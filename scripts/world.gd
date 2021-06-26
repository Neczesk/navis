extends Spatial

export var wind_strength = 13.4
export var wind_heading: float = 0

func set_wind(strength: float, direction: float):
	wind_strength = strength
	wind_heading = direction
	for child in get_children():
		if "wind_strength" in child:
			child.wind_strength = wind_strength
		if "wind_direction" in child:
			child.wind_direction = degrees_to_vector(wind_heading)
		if "wind_heading" in child:
			child.wind_heading = wind_heading
	$heading_viewport/compass_dial.wind_direction = wind_heading
	
	$ui_layer/margin_container/main_vbox/top_panel/navigation_display/wind_strength_label.text = str(wind_strength) + " KM/H"

func _ready():
	set_wind(10, 0)
	$airship.ballast_display = $ui_layer/margin_container/main_vbox/play_window/elevation_display/ballast_display/current_ballast
	
	
func degrees_to_vector(degrees: float) -> Vector2:
	return Vector2(sin(deg2rad(degrees)), cos(deg2rad(degrees)))

var time: float = 0.0

func _physics_process(delta):
	$heading_viewport/compass_dial.heading = $airship.rotation_degrees.y
	$ui_layer/margin_container/main_vbox/top_panel/navigation_display/ground_speed_label.text = str(round($airship.ground_speed_current)) + " KM/H"
	$ui_layer/margin_container/main_vbox/play_window/elevation_display/elevation_label.text = str(round($airship.global_transform.origin.y)) + " m (Sea Level)"
