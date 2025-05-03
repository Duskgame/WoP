extends Control

class_name Pause

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"
const world_menu = preload("res://scenes/world_menu.tscn")
const WORLD_SPELLBOOK = preload("res://scenes/world_spellbook.tscn")

func _ready() -> void:
	pass

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)


func pause_everything():
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)
	State.paused = true
	print(str(State.paused))
	

func unpause_everything():
	pause_group(ENEMIES_GROUP_NAME, false)
	pause_group(PLAYER_GROUP_NAME, false)
	State.paused = false
	print(str(State.paused))


func _on_pause_button_pressed() -> void:
	if self.has_node("WorldMenu"):
		State.unpause_everything()
	else:
		State.pause_everything()
		var menu_instannce = world_menu.instantiate()
		add_child(menu_instannce)


func _on_spellbook_pressed() -> void:
	if self.has_node("WorldSpellbook"):
		State.unpause_everything()
	else:
		State.pause_everything()
		var player: player_body = get_tree().get_first_node_in_group(PLAYER_GROUP_NAME)
		var spellbook_instance: WorldSpellbook = WORLD_SPELLBOOK.instantiate()
		add_child(spellbook_instance)
		spellbook_instance.instanciate_world_spellbook(player.spellbook)
		spellbook_instance.connect("book_closed", _on_spellbook_closed)

func _on_spellbook_closed() -> void:
	State.unpause_everything()
	
