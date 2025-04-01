extends CharacterBody2D

class_name PlayerBody

signal battle_detected(enemy: EnemyBody)

const SPEED = 100.0

@export var spellbook: SpellBookResource

@onready var sprite = $Eli1
@onready var collision_polygon = $CollisionPolygon2D
@onready var move: MovementComponent = $MovementComponent

var enemy: EnemyBody = null


func _ready() -> void:
	pass

func instanciate_player_body():
	add_to_group("Player")
	get_collision_polygon()

func _physics_process(delta: float) -> void:
	
	velocity = move.handle_movement(SPEED, velocity)
	if velocity.x < 0:
		sprite.flip_h = false
			
	elif velocity.x > 0:
		sprite.flip_h = true
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		if body == EnemyBody:
			save_spellbook_resource()
			enemy = body
			enemy.start_battle()
			battle_detected.emit(body)

	move_and_slide()


func get_collision_polygon():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(sprite.texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, sprite.texture.get_size()))
	collision_polygon.polygon = polygons[0] 

func save_spellbook_resource():
	SaveSpellbook.save_spellbook_resource(spellbook)
	
func load_spellbook_resource():
	spellbook = SaveSpellbook.load_spellbook_resource()
