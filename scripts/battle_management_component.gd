extends Node

class_name BattleManagementComponent

signal battle_detected(battle: Battle)
signal battle_ended
signal player_won

const BATTLE_SCENE_PATH = "res://scenes/battle/battle2.0.tscn"
const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"

var enemy_body: EnemyBody
var battle_scene: PackedScene
var sprite: Sprite2D
var collision_shape: CollisionShape2D

func initialize(body: EnemyBody, enemy_sprite: Sprite2D, enemy_collision_shape: CollisionShape2D):
	self.enemy_body = body
	self.battle_scene = preload(BATTLE_SCENE_PATH)
	self.sprite = enemy_sprite
	self.collision_shape = enemy_collision_shape
	

func start_battle():
	collision_shape.set_deferred("disabled", true)
	if get_tree().get_nodes_in_group("active_battle").size() > 0:
		print("A battle is already active.")
		return
	
	var battle_instance: Battle = battle_scene.instantiate()
	battle_detected.emit(battle_instance)
	if battle_instance.has_node("Enemy"):
		battle_instance.get_node("Enemy").enemy_resource = enemy_body.enemy_resource
	
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)

	get_tree().root.add_child(battle_instance)
	battle_instance.start_battle()

	battle_instance.connect("battle_ended", _on_battle_ended)
	battle_instance.connect("player_won", _on_player_won)


#Just used by the monster den instance
func start_boss_battle():
	collision_shape.set_deferred("disabled", true)
	if get_tree().get_nodes_in_group("active_battle").size() > 0:
		print("A battle is already active.")
		return
	
	var battle_instance: Battle = battle_scene.instantiate()
	battle_detected.emit(battle_instance)
	if battle_instance.has_node("Enemy"):
		battle_instance.get_node("Enemy").enemy_resource = enemy_body.enemy_resource
	
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)

	get_tree().root.add_child(battle_instance)
	battle_instance.start_boss_battle()

	battle_instance.connect("battle_ended", _on_battle_ended)
	battle_instance.connect("player_won", _on_player_won)

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)


func _on_battle_ended():
	battle_ended.emit()
	pause_group(PLAYER_GROUP_NAME, false)
	await get_tree().create_timer(1).timeout
	pause_group(ENEMIES_GROUP_NAME, false)
	if collision_shape != null:
		collision_shape.set_deferred("disabled", false)
	else:
		return
		


func _on_player_won():
	player_won.emit()
	battle_ended.emit()
	sprite.queue_free()
	collision_shape.queue_free()
	pause_group(PLAYER_GROUP_NAME, false)
	await get_tree().create_timer(1).timeout
	pause_group(ENEMIES_GROUP_NAME, false)
	enemy_body.queue_free()
