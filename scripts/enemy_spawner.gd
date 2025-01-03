extends Control

signal spawned_name(name: String)


func _ready() -> void:
	pass

func spawn_enemy():
	var enemy_scene = preload("res://scenes/enemy.tscn")
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.enemy = preload("res://Resources/enemies/firesalamander.tres")
	add_child(enemy_instance)
	spawned_name.emit(enemy_instance.enemy_name)

func start_fight():
	get_child(1)
	
