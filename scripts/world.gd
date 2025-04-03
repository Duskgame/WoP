extends Node2D

class_name world

const ENEMIES_GROUP_NAME = "Enemies"

@onready var player: player_body = $PlayerBody
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	player.instanciate_player_body()
	for enemy in get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME):
		enemy.connect("battle_detected", _on_battle_detected)
		enemy.connect("battle_ended", load_player_spellbook_resource)

func _process(delta: float) -> void:
	camera.global_position = player.global_position
	
func _on_battle_detected(battle: Battle):
	camera.global_position = battle.global_position
	
func load_player_spellbook_resource():
	player.load_spellbook_resource()

func end_game():
		await get_tree().create_timer(1).timeout
		print("escape")
		queue_free()
