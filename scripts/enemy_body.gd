extends CharacterBody2D

class_name EnemyBody

signal battle_detected

const BATTLE = preload("res://scenes/battle/battle2.0.tscn")
const ENEMIES = "enemies"

@export var detection_radius: float = 400

@onready var enemy_resource: EnemyResource 
@onready var SPEED: float = 50
@onready var wander_time: float = 3.0
@onready var enemy_sprite: Sprite2D = $Sprite2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var collision_shape:CollisionShape2D = $CollisionShape2D

var direction: Vector2 = Vector2.ZERO
var player: PlayerBody = null


func _ready() -> void:
	
	initialize_enemy()
	randomize_direction()


func _physics_process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player and global_position.distance_to(player.global_position) <= detection_radius:
		chase_player(delta)
		#check_for_collision(delta)
	else:
		random_movement(delta)
		#check_for_collision(delta)


func initialize_enemy():
	add_to_group(ENEMIES)
	if enemy_resource:
		SPEED = enemy_resource.speed
		enemy_sprite.texture = enemy_resource.texture
		collision_polygon.polygon = enemy_resource.get_texture_polygon()


func random_movement(delta):
	velocity = direction * SPEED
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		handle_collision(collision)
	
	wander_time -= delta
	if wander_time <= 0:
		randomize_direction()
		wander_time = randf_range(2.0, 4.0)
		

func randomize_direction():
	while true:
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
		if direction != Vector2.ZERO:
			break
	enemy_sprite.flip_h = direction.x < 0
	
	
func chase_player(delta):
	velocity = global_position.direction_to(player.global_position) * SPEED 
	move_and_slide()
	
	
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
		handle_collision(collision)


func handle_collision(collision: KinematicCollision2D):
	var body = collision.get_collider()
	if body is PlayerBody:
		start_battle()
	elif body is EnemyBody:
		return
	else:
		randomize_direction()


func start_battle():
	if get_tree().get_nodes_in_group("active_battle").size() > 0:
		print("A battle is already active.")
		return
		
	var battle: Battle = BATTLE.instantiate()
	if battle == null:
		print("Failed to instantiate battle scene!")
		return
	
	if battle.has_node("Enemy"):
		battle.get_node("Enemy").enemy_resource = enemy_resource
	
	battle_detected.emit()
	
	set_pause_group(ENEMIES, true)
	set_pause_group("Player", true)
	get_tree().root.add_child(battle)
	get_tree().current_scene = battle
	
	battle.connect("battle_ended", Callable(self, "_on_battle_ended"))
	battle.connect("player_won", Callable(self, "_on_player_won"))

func set_pause_group(group_name: String, pause: bool):
	var nodes = get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		node.set_process(!pause)
		node.set_physics_process(!pause)
		node.set_physics_process_internal(!pause)
		node.set_process_unhandled_input(!pause)

func _on_battle_ended():
	set_pause_group("Player", false)
	await get_tree().create_timer(1).timeout
	set_pause_group(ENEMIES, false)

func _on_player_won():
	enemy_sprite.queue_free()
	collision_polygon.queue_free()
	set_pause_group("Player", false)
	await get_tree().create_timer(1).timeout
	set_pause_group(ENEMIES, false)
	print("delete enemy")
	queue_free()

func _on_random_enemy_spawner_random_enemy(random_enemy: EnemyResource) -> void:
	enemy_resource = random_enemy
