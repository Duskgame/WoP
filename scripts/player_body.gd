extends CharacterBody2D

class_name PlayerBody

signal battle_detected(enemy: EnemyBody)

const SPEED = 100.0

@export var spellbook: SpellBookResource

@onready var sprite = $Eli1
@onready var collision_polygon = $CollisionPolygon2D
#@onready var polygon = $Eli1/Area2D/Polygon2D
@onready var area = $Eli1/Area2D
@onready var move: MovementComponent = $MovementComponent


func _ready() -> void:
	add_to_group("Player")
	get_collision_polygon()
	#get_area()
	

func _physics_process(delta: float) -> void:
	
	velocity = move.handle_movement(SPEED, velocity, sprite)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		battle_detected.emit(body)

	move_and_slide()


func get_collision_polygon():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(sprite.texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, sprite.texture.get_size()))
	collision_polygon.polygon = polygons[0] 
	
	
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
