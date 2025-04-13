extends CharacterBody2D

class_name player_body

signal battle_detected(enemy: EnemyBody)

const SPEED = 100.0

@export var spellbook: SpellBookResource

@onready var animated_sprite = $AnimatedSprite2D
@onready var move: MovementComponent = $MovementComponent

var enemy: EnemyBody = null


func _ready() -> void:
	pass

func instanciate_player_body() -> void:
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	
	velocity = move.handle_movement(SPEED, velocity)
	if velocity.y < 0:
		animated_sprite.play("up")
			
	elif velocity.y > 0:
		animated_sprite.play("down")
	
	elif velocity.x < 0:
		animated_sprite.play("left")
		
	elif velocity.x > 0:
		animated_sprite.play("right")

	else:
		animated_sprite.stop()
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		if body is EnemyBody:
			save_spellbook_resource()
			enemy = body
			enemy.battle_component.start_battle()
			battle_detected.emit(body)

	move_and_collide(velocity * delta)


func save_spellbook_resource() -> void:
	SaveSpellbook.save_spellbook_resource(spellbook)
	
func load_spellbook_resource() -> void:
	spellbook = SaveSpellbook.load_spellbook_resource()
