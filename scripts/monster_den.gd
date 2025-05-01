extends StaticBody2D

class_name MonsterDen

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"

@export var possible_monster_to_spawn: Array[PackedScene]

@onready var SpawnArea: Area2D = $SpawnArea
@onready var SpawnPoint: Node2D = $SpawnPoint
@onready var SpawnTimer: Timer = $SpawnTimer

var bodies_inside: Array
var monster_to_spawn: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_to_spawn = possible_monster_to_spawn.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SpawnTimer.paused = State.paused


func _on_spawn_timer_timeout() -> void:
	if len(bodies_inside) == 0:
		if len(get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME)) < 20:
			var monster_instance: EnemyBody = monster_to_spawn.instantiate()
			add_child(monster_instance)
			monster_instance.global_position = SpawnPoint.global_position


func _on_spawn_area_body_entered(body: Node2D) -> void:
	if body is EnemyBody or body is player_body:
		bodies_inside.append(body)
	print(bodies_inside)


func _on_spawn_area_body_exited(body: Node2D) -> void:
	bodies_inside.erase(body)

func _on_pause_changed(pause: bool):
	SpawnTimer.paused = pause
