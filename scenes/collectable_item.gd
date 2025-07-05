extends Item

class_name CollectableItem

@onready var area: Area2D = $Area2D


var collectable: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player_body:
		collectable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	collectable = false
