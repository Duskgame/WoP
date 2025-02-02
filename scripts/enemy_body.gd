extends CharacterBody2D

class_name EnemyBody

signal battle_detected

const BATTLE = preload("res://scenes/battle/battle2.0.tscn")

@export var enemy_resource: EnemyResource 

@onready var SPEED = enemy_resource.speed
@onready var enemy_sprite: Sprite2D = $Sprite2D
@onready var collision_polygon = $CollisionPolygon2D

func _ready() -> void:
	get_collision_polygon()
	
func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		print("bam")
		var battle = BATTLE.instantiate()
		battle.enemy.enemy_resource = enemy_resource
		battle_detected.emit()
		add_child(battle)

	move_and_slide()

func get_collision_polygon():
	enemy_sprite.texture = enemy_resource.texture
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(enemy_sprite.texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, enemy_sprite.texture.get_size()))
	collision_polygon.polygon = polygons[0]  # Use the first generated polygon

func get_movement():
	
	var vertical_direction := Input.get_axis("ui_left", "ui_right")
	
	if vertical_direction:
		velocity.x = vertical_direction * SPEED
		if vertical_direction == -1:
			enemy_sprite.flip_h = false
		else:
			enemy_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var horizontal_direction := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction:
		velocity.y = horizontal_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
