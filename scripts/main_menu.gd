extends Control

const world = preload("res://scenes/world.tscn")
const warmup = preload("res://scenes/battle/battle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	await  get_tree().create_timer(1.5).timeout
	get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(world)


func _on_warmup_pressed() -> void:
	get_tree().change_scene_to_packed(warmup)
