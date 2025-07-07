extends Node

class_name RandomEnemySpawner

@export var possible_enemies: Array[EnemyResource]

func get_random_enemy() -> EnemyResource:
	var enemy: EnemyResource = possible_enemies.pick_random()
	#print(enemy.name)
	return enemy
