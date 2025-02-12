extends Node

class_name EnemyInitializationComponent

var enemy_body: EnemyBody
var sprite: Sprite2D
var collision_polygon: CollisionPolygon2D

func initialize(body: EnemyBody, enemy_sprite: Sprite2D, enemy_collision_polygon: CollisionPolygon2D):
	self.enemy_body = body
	self.sprite = enemy_sprite
	self.collision_polygon = enemy_collision_polygon
	
	
	if enemy_body.enemy_resource:
		enemy_body.speed = enemy_body.enemy_resource.speed
		sprite.texture = enemy_body.enemy_resource.texture
		collision_polygon.polygon = enemy_body.enemy_resource.get_texture_polygon()
