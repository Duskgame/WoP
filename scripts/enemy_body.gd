extends CharacterBody2D

class_name EnemyBody

signal battle_detected(own_position)

const ENEMIES_GROUP_NAME = "enemies"

@onready var enemy_resource: EnemyResource = null
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var initialization_component: EnemyInitializationComponent = $EnemyInitializationComponent
@onready var movement_component: EnemyMovementComponent = $EnemyMovementComponent
@onready var collision_component: EnemyCollisionComponent = $EnemyCollisionComponent
@onready var battle_component: BattleManagementComponent = $BattleManagementComponent
@onready var detection_component: PlayerDetectionComponent = $PlayerDetectionComponent
@onready var random_enemy: RandomEnemySpawner = $RandomEnemySpawner
@onready var speed: float = 0

var player: PlayerBody = null

func _ready() -> void:
	
	add_to_group(ENEMIES_GROUP_NAME)
	enemy_resource = random_enemy.get_random_enemy()
	initialization_component.initialize(self, sprite, collision_polygon)
	movement_component.initialize(self, sprite)
	collision_component.initialize(self, movement_component)
	battle_component.initialize(self, sprite, collision_polygon)
	battle_component.connect("battle_detected", _on_battle_detected)
	detection_component.initialize(self)

	movement_component.randomize_direction()


func _physics_process(delta: float) -> void:
	# Detect player
	player = detection_component.detect_player()
	
	if player:
		movement_component.chase_player(player.global_position, delta)
		collision_component.check_for_collision(delta)
	else:
		movement_component.random_movement(delta)
		collision_component.check_for_collision(delta)
		

func _on_battle_detected(battle: Battle):
	SaveSystem.save_game()
	SceneSystem.set_temp_data("enemy_position", self.global_position)
	battle_detected.emit(self.global_position)
