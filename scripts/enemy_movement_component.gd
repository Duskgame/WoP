extends Node

class_name EnemyMovementComponent

@export var speed: float = 50

var direction: Vector2 = Vector2.ZERO
var wander_time: float = 3.0

var enemy_body: CharacterBody2D
var sprite: Sprite2D

func initialize(body: CharacterBody2D, enemy_sprite: Sprite2D):
	self.enemy_body = body
	self.sprite = enemy_sprite
	speed = enemy_body.speed


func randomize_direction():
	while true:
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		if direction != Vector2.ZERO:
			break
	if direction.x < 0:
		sprite.flip_h = false
			
	elif direction.x > 0:
		sprite.flip_h = true


func random_movement(delta):
	var velocity = direction * speed
	enemy_body.velocity = velocity  # Update parent velocity for collisions
	enemy_body.move_and_collide(velocity * delta)

	wander_time -= delta
	if wander_time <= 0:
		randomize_direction()
		wander_time = randf_range(2.0, 4.0)


func chase_player(player_position: Vector2, delta):
	direction = enemy_body.global_position.direction_to(player_position).normalized()
	var velocity = direction * speed
	enemy_body.velocity = velocity  # Update parent velocity for collisions
	enemy_body.move_and_collide(velocity * delta)
