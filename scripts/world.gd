extends Node2D

class_name world

const ENEMIES_GROUP_NAME = "Enemies"
const COLLECTABLE_SPELLS = "CollectableSpells"

@onready var player: player_body = $PlayerBody
@onready var camera: Camera2D = $Camera2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: Pause = $Camera2D/Pause


func _ready() -> void:
	player.instanciate_player_body()
	for enemy in get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME):
		enemy.connect("battle_detected", _on_battle_detected)
		enemy.connect("battle_ended", load_player_spellbook_resource)
		enemy.connect("battle_ended", _on_battle_ended)
	for spell in get_tree().get_nodes_in_group(COLLECTABLE_SPELLS):
		spell.connect("spell_learned", _on_spell_to_collect_spell_learned)

func _process(delta: float) -> void:
	camera.global_position = player.global_position
	
func _on_battle_detected(battle: Battle):
	camera.global_position = battle.global_position
	ui.hide()
	
func _on_battle_ended() -> void:
	ui.show()
	
func load_player_spellbook_resource():
	player.load_spellbook_resource()

func end_game():
		await get_tree().create_timer(1).timeout
		print("escape")
		queue_free()


func _on_spell_to_collect_spell_learned(spell: SpellResource) -> void:
	var message = preload("res://scenes/spell_learned_message.tscn")
	var message_instance = message.instantiate()
	camera.add_child(message_instance)
	message_instance.set_text(spell)
