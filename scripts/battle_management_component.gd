extends Node

class_name BattleManagementComponent

signal battle_detected(battle: Battle)

const BATTLE_SCENE_PATH = "res://scenes/battle/battle2.0.tscn"
const ENEMIES_GROUP_NAME = "enemies"
const PLAYER_GROUP_NAME = "Player"

var enemy_body: EnemyBody
var battle_scene: PackedScene
var sprite: Sprite2D
var collision_polygon: CollisionPolygon2D

func initialize(body: EnemyBody, enemy_sprite: Sprite2D, enemy_collision_polygon: CollisionPolygon2D):
	self.enemy_body = body
	self.battle_scene = preload(BATTLE_SCENE_PATH)
	self.sprite = enemy_sprite
	self.collision_polygon = enemy_collision_polygon


func start_battle():
	if get_tree().get_nodes_in_group("active_battle").size() > 0:
		print("A battle is already active.")
		return
	
	SceneSystem.set_temp_data("enemy_resource", enemy_body.enemy_resource)
	SceneSystem.set_temp_data("player_spellbook", get_tree().get_first_node_in_group(PLAYER_GROUP_NAME).spellbook_resource)
	
	print(SceneSystem.temp_data)
	
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)

	SceneSystem.switch_scene("battle")
	

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)


func _on_battle_ended():
	pause_group(PLAYER_GROUP_NAME, false)
	await get_tree().create_timer(1).timeout
	pause_group(ENEMIES_GROUP_NAME, false)


func _on_player_won():
	sprite.queue_free()
	collision_polygon.queue_free()
	pause_group(PLAYER_GROUP_NAME, false)
	await get_tree().create_timer(1).timeout
	pause_group(ENEMIES_GROUP_NAME, false)
	enemy_body.queue_free()
