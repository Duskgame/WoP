extends CollectableItem

class_name CollectableEssence

@onready var area: Area2D = $DetectionArea
@onready var movement_body: CharacterBody2D = $CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D

@export var element: Spells.ELEMENTS
@export var sprites: Array[CompressedTexture2D]

var direction: Vector2
var playerbody: player_body
var speed: float = 5

func instanciate_essence(enemy_element: Spells.ELEMENTS):
	element = enemy_element
	sprite.texture = sprites[element]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collectable:
		await get_tree().create_timer(1).timeout
		chase_player(playerbody.global_position,delta)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player_body:
		collectable = true
		playerbody = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	collectable = false


func _on_collection_area_body_entered(body: Node2D) -> void:
	var essence = Essence.new()
	essence.element = self.element
	match element:
		Spells.ELEMENTS.FIRE:
			State.fire_essence += 1
			print("fire essence " + str(State.fire_essence))
		Spells.ELEMENTS.WATER:
			State.water_essence += 1
			print("water essence " + str(State.water_essence))
		Spells.ELEMENTS.ICE:
			State.ice_essence += 1
			print("ice essence " + str(State.ice_essence))
	self.queue_free()


func chase_player(player_position: Vector2, delta):
	direction = movement_body.global_position.direction_to(player_position).normalized()
	speed = movement_body.global_position.distance_to(player_position)
	#print(speed)
	var velocity = direction * speed
	movement_body.velocity = velocity
	movement_body.move_and_collide(velocity * delta)
	self.global_position = movement_body.global_position
