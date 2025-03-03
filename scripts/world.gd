extends Node2D

class_name World

const ENEMIES_GROUP_NAME = "enemies"

var battle_scene = preload("res://scenes/battle/battle2.0.tscn")
var current_battle: Battle = null

@onready var player: PlayerBody = $PlayerBody
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME):
		enemy.connect("battle_detected", _on_battle_detected)
	player.connect("collided_with_enemy", _on_player_collided_with_enemy)

func _process(delta: float) -> void:
	camera.global_position = player.global_position

func _on_player_collided_with_enemy(player: PlayerBody, enemy: EnemyBody):
	start_battle(enemy)

func _on_battle_detected(enemy: EnemyBody):
	start_battle(enemy)

func start_battle(enemy: EnemyBody):
	current_battle = battle_scene.instantiate()
	add_child(current_battle)
	current_battle.initialize(player.spellbook_resource, enemy.enemy_resource, enemy)
	current_battle.connect("battle_ended", _on_battle_ended)
	get_tree().paused = true
	current_battle.start_battle()

func _on_battle_ended(player_won: bool):
	get_tree().paused = false 
	if player_won:
		current_battle.enemy_body.queue_free()
	SaveSystem.update_after_battle(player_won, current_battle.enemy_body.global_position)
	current_battle.queue_free()
	current_battle = null

func end_game():
	await get_tree().create_timer(1).timeout
	print("escape")
	queue_free()
