extends Node

class_name RandomEnemySpawner

signal random_enemy(random_enemy: EnemyResource)

@export var possible_enemies: Array[EnemyResource]


func _ready() -> void:
	random_enemy.emit(get_random_enemy())


func get_random_enemy() -> EnemyResource:
	var enemy: EnemyResource = possible_enemies.pick_random()
	print(enemy.name)
	return enemy
