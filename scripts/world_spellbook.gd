extends Control

class_name WorldSpellbook

signal book_closed
signal ritual_started(ritual_instance: RitualMiniGame)


@onready var spellbook: Spellbook = $Spellbook2


func _ready() -> void:
	pass 
	
func instanciate_world_spellbook(spellbook_resource: SpellBookResource):
	spellbook.instanciate_spellbook(spellbook_resource)
	spellbook.connect("ritual_started", _on_ritual_started)

func _on_back_to_game_pressed() -> void:
	spellbook.play_closing()
	await spellbook.opening_animation.animation_finished
	book_closed.emit()
	queue_free()

func _on_ritual_started(ritual_instance: RitualMiniGame):
	ritual_started.emit(ritual_instance)
