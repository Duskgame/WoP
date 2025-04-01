extends Control

const world_scene = preload("res://scenes/world.tscn")
const warmup = preload("res://scenes/battle/battle.tscn")
const test_spellbook = preload("res://Resources/Spells/spellbook/spellbook.tres")
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
	get_tree().change_scene_to_packed(world_scene)
	SaveSpellbook.save_spellbook_resource(test_spellbook)


func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_packed(world_scene)


func _on_warmup_pressed() -> void:
	get_tree().change_scene_to_packed(warmup)
