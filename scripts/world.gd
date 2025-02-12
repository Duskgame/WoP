extends Node2D

class_name world

@onready var player = $PlayerBody

func _process(delta: float) -> void:
	pass

func _on_battle_detected():
	pass

func end_game():
		await get_tree().create_timer(1).timeout
		print("escape")
		queue_free()
