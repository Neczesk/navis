extends Spatial

# This script is intended to be used with airship scenes

export var bouyancy: float setget set_bouyancy
var min_bouyancy: float
var max_bouyancy: float
var bouyant_force: Vector3

func set_bouyancy(new_bouyancy):
	bouyancy = clamp(new_bouyancy, min_bouyancy, max_bouyancy)
	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	bouyant_force = Vector3(0.0, bouyancy, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
