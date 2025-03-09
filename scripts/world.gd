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
	print("World scene ready. Enemy count: ", get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME).size())

func _process(delta: float) -> void:
	if not current_battle:
		camera.global_position = player.global_position

func _on_battle_detected(enemy: EnemyBody):
	print("Battle detected with enemy: ", enemy)
	start_battle(enemy)

func start_battle(enemy: EnemyBody):
	print("Starting battle with enemy: ", enemy)
	if current_battle:
		print("Error: A battle is already in progress")
		return

	current_battle = battle_scene.instantiate()
	if not current_battle:
		print("Error: Failed to instantiate battle scene")
		return

	if not is_instance_valid(player) or not player.spellbook_resource:
		print("Error: Player or spellbook resource is invalid")
		current_battle.queue_free()
		current_battle = null
		return

	current_battle.initialize(player.spellbook_resource, enemy.enemy_resource, enemy)
	current_battle.connect("battle_ended", _on_battle_ended)
	
	add_child(current_battle)
	print("Battle scene added to the tree")

	current_battle.start_battle()
	get_tree().paused = true
	print("Battle started and tree paused")

func _on_battle_ended(player_won: bool):
	print("Battle ended. Player won: ", player_won)
	get_tree().paused = false 
	if player_won and is_instance_valid(current_battle.enemy_body):
		current_battle.enemy_body.queue_free()
		print("Enemy removed from the world")
	SaveSystem.update_after_battle(player_won, current_battle.enemy_body.global_position)
	current_battle.queue_free()
	current_battle = null
	camera.make_current()
	print("World scene restored")

func end_game():
	await get_tree().create_timer(1).timeout
	print("Game ended")
	queue_free()
