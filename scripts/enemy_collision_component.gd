extends Node

class_name EnemyCollisionComponent

var enemy_body: CharacterBody2D
var movement_component: EnemyMovementComponent

func initialize(body: CharacterBody2D, enemy_movement_component: EnemyMovementComponent):
	self.enemy_body = body
	self.movement_component = enemy_movement_component


func check_for_collision(delta):
	var velocity = enemy_body.velocity * delta
	var collision = enemy_body.move_and_collide(velocity)
	
	if collision:
		handle_collision(collision)


func handle_collision(collision: KinematicCollision2D):
	var body = collision.get_collider()
	
	if body is PlayerBody:
		enemy_body.battle_component.start_battle()
	elif body is EnemyBody:
		return  # Ignore other enemies
	else:
		movement_component.randomize_direction()
