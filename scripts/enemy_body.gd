extends CharacterBody2D

class_name EnemyBody

signal battle_detected

const BATTLE = preload("res://scenes/battle/battle2.0.tscn")

@onready var enemy_resource: EnemyResource 
@onready var SPEED = enemy_resource.speed
@onready var wander_time: float = 3.0
@onready var enemy_sprite: Sprite2D = $Sprite2D
@onready var collision_polygon = $CollisionPolygon2D

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	initialize_enemy()
	randomize_direction()
	
func _physics_process(delta: float) -> void:
	simple_movement(delta)
	check_for_collision(delta)

	move_and_slide()

func initialize_enemy():
	if enemy_resource:
		SPEED = enemy_resource.speed
		enemy_sprite.texture = enemy_resource.texture
		setup_collision_polygon()
	
func setup_collision_polygon():
	if not enemy_sprite.texture:
		return
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(enemy_sprite.texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, enemy_sprite.texture.get_size()))
	collision_polygon.polygon = polygons[0]  # Use the first generated polygon


func simple_movement(delta):
	velocity = direction * SPEED
	move_and_slide()
	var slide_sollision = get_last_slide_collision()
	if slide_sollision:
		randomize_direction()
	
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_direction()
		wander_time = randf_range(2.0, 4.0)
		

func randomize_direction():
	while true:
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		if direction != Vector2.ZERO:
			break
	
	enemy_sprite.flip_h = direction.x < 0
	
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
	
func check_for_collision(delta: float):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		print(body)
		if body is PlayerBody:
			print(collision)
			var battle = BATTLE.instantiate()
			if battle == null:
				print("Failed to instantiate battle scene!")
				return
			print("Battle scene instantiated successfully.")
			
			if battle.has_node("Enemy"):
				print("Enemy node found in battle scene.")
				battle.get_node("Enemy").enemy_resource = enemy_resource
				print(battle.enemy)
			else:
				print("Battle scene does not have an 'Enemy' node!")
				
			battle.call_deferred("setup_battle", enemy_resource)
			battle_detected.emit()
			print("Replacing current scene...")
			battle.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
			get_tree().paused = true
			get_tree().root.add_child(battle)
			get_tree().current_scene = battle
			battle.connect("battle_ended", _on_battle_ended)
		else:
			randomize_direction()

func _on_battle_ended():
	get_tree().paused = false
	queue_free()

func _on_random_enemy_spawner_random_enemy(random_enemy: EnemyResource) -> void:
	enemy_resource = random_enemy
