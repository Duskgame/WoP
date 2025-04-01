extends Control

class_name Pause

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"
const world_menu = preload("res://scenes/world_menu.tscn")

func _ready() -> void:
	pass

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)

func _on_pause_button_pressed() -> void:
	if self.has_node("WorldMenu"):
		pause_group(ENEMIES_GROUP_NAME, false)
		pause_group(PLAYER_GROUP_NAME, false)
	else:
		pause_group(ENEMIES_GROUP_NAME, true)
		pause_group(PLAYER_GROUP_NAME, true)
		var menu_instannce = world_menu.instantiate()
		add_child(menu_instannce)
