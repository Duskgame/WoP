extends Node

class_name EnemyInitializationComponent

var enemy_body: EnemyBody
var sprite: Sprite2D
var collision_shape: CollisionShape2D

func initialize(body: EnemyBody, enemy_sprite: Sprite2D, enemy_collision_shape: CollisionShape2D):
	self.enemy_body = body
	self.sprite = enemy_sprite
	self.collision_shape = enemy_collision_shape
	
	
	if enemy_body.enemy_resource:
		enemy_body.speed = enemy_body.enemy_resource.speed
		sprite.texture = enemy_body.enemy_resource.texture
		#collision_polygon.polygon = enemy_body.enemy_resource.get_texture_polygon()
