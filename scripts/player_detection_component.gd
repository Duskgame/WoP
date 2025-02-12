extends Node

class_name PlayerDetectionComponent

@export var detection_radius: float = 400

var enemy_body: CharacterBody2D

func initialize(body: CharacterBody2D):
	self.enemy_body = body


func detect_player() -> PlayerBody:
	var player_node = get_tree().get_first_node_in_group("Player")
	
	if player_node and enemy_body.global_position.distance_to(player_node.global_position) <= detection_radius:
		return player_node as PlayerBody
	
	return null
