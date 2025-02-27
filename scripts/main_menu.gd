extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	await  get_tree().create_timer(1).timeout
	SceneSystem.quit_game()


func _on_start_button_pressed() -> void:
	SceneSystem.switch_scene("world")
