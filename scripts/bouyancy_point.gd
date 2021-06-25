extends Spatial

# This script is intended to be used with airship scenes

export var base_bouyancy: float
var bouyancy_mod: float = 100 setget set_bouyancy_mod

func set_bouyancy_mod(new_mod: float):
	bouyancy_mod = clamp(new_mod, 50, 200)

var bouyant_force: Vector3
	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	bouyant_force = Vector3(0.0, base_bouyancy * (bouyancy_mod/100), 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
