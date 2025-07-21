extends Node

class_name Sate

var current_health = 25
var max_health = 25
var current_position: Vector2

var fire_essence: int
var water_essence: int
var ice_essence: int

var essences = [fire_essence, water_essence, ice_essence]

var wins: float = 0
var losses: float = 0

var win_modifier: float = 0.05
var loss_modifier: float = 0.05

var damage_modifier: float = 1

var enemy_damage_modifier: float = 0.5
var enemy_speed_modifier: float = 1.5
var enemy_health_modifier: float = 0.5

var paused: bool = false



const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"

func pause_group(group_name: String, pause: bool):
	for node in get_tree().get_nodes_in_group(group_name):
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)

func pause_node(node: Node, pause: bool):
	node.set_process(!pause)
	node.set_physics_process(!pause)
	node.set_physics_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	print("paused " + str(node))

func pause_everything():
	SaveSpellbook.save_state()
	pause_group(ENEMIES_GROUP_NAME, true)
	pause_group(PLAYER_GROUP_NAME, true)
	State.paused = true
	print(str(State.paused))
	

func unpause_everything():
	pause_group(ENEMIES_GROUP_NAME, false)
	pause_group(PLAYER_GROUP_NAME, false)
	State.paused = false
	print(str(State.paused))

func get_current_position():
	var player: player_body = get_tree().get_first_node_in_group(PLAYER_GROUP_NAME)
	if player:
		current_position = player.global_position
