extends Control

class_name Pause

signal ritual_started(ritual_instance: RitualMiniGame)

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"
const world_menu = preload("res://scenes/world_menu.tscn")
const WORLD_SPELLBOOK = preload("res://scenes/world_spellbook.tscn")

@onready var pause_button: Button = $PauseButton
@onready var spellbook_button: Button = $Spellbook_Button

var world_spellbook: WorldSpellbook

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
		create_spellbook()

func create_spellbook():
	var player: player_body = get_tree().get_first_node_in_group(PLAYER_GROUP_NAME)
	var spellbook_instance: WorldSpellbook = WORLD_SPELLBOOK.instantiate()
	add_child(spellbook_instance)
	world_spellbook = spellbook_instance
	spellbook_instance.instanciate_world_spellbook(player.spellbook)
	spellbook_instance.connect("ritual_started", _on_ritual_started)
	spellbook_instance.connect("initiating_ritual", _on_initiating_ritual)
	spellbook_instance.connect("stopping_initiation", _on_stopping_initiation)
	spellbook_instance.connect("book_closed", _on_spellbook_closed)

func _on_spellbook_closed() -> void:
	State.unpause_everything()
	
func _on_ritual_started(ritual_instance: RitualMiniGame):
	ritual_started.emit(ritual_instance)

func _on_initiating_ritual():
	pause_button.disabled = true
	spellbook_button.disabled = true
	
func _on_stopping_initiation():
	pause_button.disabled = false
	spellbook_button.disabled = false
	
	
