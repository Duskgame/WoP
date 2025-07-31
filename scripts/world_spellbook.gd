extends Control

class_name WorldSpellbook

signal book_closed
signal ritual_started(ritual_instance: RitualMiniGame)
signal initiating_ritual
signal stopping_initiation


@onready var spellbook: Spellbook = $Spellbook2
@onready var back_button: Button = $BackToGame


func _ready() -> void:
	pass 
	
func instanciate_world_spellbook(spellbook_resource: SpellBookResource):
	spellbook.instanciate_spellbook(spellbook_resource)
	spellbook.connect("ritual_started", _on_ritual_started)
	spellbook.connect("initiating_ritual", _on_initiating_ritual)
	spellbook.connect("stopping_initiation", _on_stopping_initiation)

func _on_back_to_game_pressed() -> void:
	spellbook.play_closing()
	await spellbook.opening_animation.animation_finished
	book_closed.emit()
	queue_free()

func _on_ritual_started(ritual_instance: RitualMiniGame):
	ritual_started.emit(ritual_instance)

func _on_initiating_ritual():
	initiating_ritual.emit()
	back_button.hide()
	
func _on_stopping_initiation():
	stopping_initiation.emit()
	back_button.show()
