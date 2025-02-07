extends CharacterBody2D

class_name PlayerBody

signal battle_detected(enemy: EnemyBody)

const SPEED = 300.0

@export var spellbook: SpellBookResource

@onready var sprite = $Eli1
@onready var collision_polygon = $CollisionPolygon2D
#@onready var polygon = $Eli1/Area2D/Polygon2D
@onready var area = $Eli1/Area2D


func _ready() -> void:
	get_collision_polygon()
	#get_area()
	

func _physics_process(delta: float) -> void:
	
	check_for_movement()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		battle_detected.emit(body)

	move_and_slide()


func check_for_movement():
	
	var vertical_direction := Input.get_axis("ui_left", "ui_right")
	
	if vertical_direction:
		velocity.x = vertical_direction * SPEED
		if vertical_direction == -1:
			sprite.flip_h = false
			
		elif vertical_direction == 1:
			sprite.flip_h = true

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var horizontal_direction := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction:
		velocity.y = horizontal_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	
func get_collision_polygon():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(sprite.texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, sprite.texture.get_size()))
	collision_polygon.polygon = polygons[0]  # Use the first generated polygon
	
	
	
#func get_area():
	#var bitmap = BitMap.new()
	#bitmap.create_from_image_alpha(sprite.texture.get_image())
	#var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, (sprite.texture.get_size()) * 1.1))
	#polygon.polygon = polygons[0]  # Use the first generated polygon
	#area.global_position.x = self.global_position.x - (sprite.texture.get_width() * 0.1)
	#area.global_position.y = self.global_position.y - (sprite.texture.get_height() * 0.1)


func _on_area_2d_body_entered(body: EnemyBody) -> void:
	print("bam")
	battle_detected.emit(body)
