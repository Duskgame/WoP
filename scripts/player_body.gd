extends CharacterBody2D

class_name player_body

signal battle_detected(enemy: EnemyBody)

const SPEED = 100.0

@export var spellbook: SpellBookResource

@onready var sprite = $Eli1
@onready var move: MovementComponent = $MovementComponent
@onready var ui: Pause = $Pause

var enemy: EnemyBody = null


func _ready() -> void:
	pass

func instanciate_player_body():
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	
	velocity = move.handle_movement(SPEED, velocity)
	if velocity.x < 0:
		sprite.flip_h = false
			
	elif velocity.x > 0:
		sprite.flip_h = true
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		print(body)
		if body is EnemyBody:
			print("yes")
			
			save_spellbook_resource()
			enemy = body
			enemy.battle_component.start_battle()
			battle_detected.emit(body)

	move_and_collide(velocity * delta)


func save_spellbook_resource():
	SaveSpellbook.save_spellbook_resource(spellbook)
	
func load_spellbook_resource():
	spellbook = SaveSpellbook.load_spellbook_resource()
