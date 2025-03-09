extends Node

class_name SceneManager

@export var Scenes: Dictionary = {}

var current_scene_name: String = ""


func _ready() -> void:
	var main_scene: StringName = ProjectSettings.get_setting("application/run/main_scene")
	current_scene_name = Scenes.find_key(main_scene as String)
	print(current_scene_name)


func add_scene(scene_name: String, scene_path: String) -> void:
	Scenes[scene_name] = scene_path
	
func remove_scene(scene_name: String) -> void:
	Scenes.erase(scene_name)

func switch_scene(scene_name: String) -> void:
	get_tree().change_scene_to_file(Scenes[scene_name])
	
func restart_scene() -> void:
	get_tree().reload_current_scene()

func quit_game() -> void:
	get_tree().quit()
	
func get_scene_count() -> int:
	return Scenes.size()
	
func get_current_scene_name() -> String:
	return current_scene_name
