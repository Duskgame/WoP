extends Control

class_name WorldMenu

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"

var spellbook = preload("res://scenes/world_spellbook.tscn")

@onready var button_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)


func _on_menu_button_pressed() -> void:
	await  get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_exit_button_pressed() -> void:
	await  get_tree().create_timer(1.5).timeout
	get_tree().quit()


func _on_back_to_game_pressed() -> void:
	pause_group(ENEMIES_GROUP_NAME, false)
	pause_group(PLAYER_GROUP_NAME, false)
	queue_free()


func _on_spellbook_pressed() -> void:
	var player: player_body = get_tree().get_first_node_in_group(PLAYER_GROUP_NAME)
	var spellbook_instance: WorldSpellbook = spellbook.instantiate()
	add_child(spellbook_instance)
	spellbook_instance.instanciate_world_spellbook(player.spellbook)
	button_container.modulate = "#ffffff00"
	
