extends Node2D

class_name world

@onready var player = $PlayerBody

func _on_battle_detected():
	pass

func end_game():
	if Input.is_key_pressed(KEY_ESCAPE):
		print("escape")
		queue_free()
