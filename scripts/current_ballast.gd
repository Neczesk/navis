tool
extends Control

onready var ballast_display: TextureRect = get_parent()
export(float, 50,200) var current_ballast = 50 setget set_current_ballast

func set_current_ballast(new_ballast):
	current_ballast = clamp(new_ballast, 50, 200)
	update()

func _ready():
	pass

func _draw():
	var y
	if ballast_display:
		y = 200 - current_ballast
		y *= ballast_display.rect_size.y / 150
	draw_line(Vector2(20, y), Vector2(50, y), Color.red, 4.0, true)
