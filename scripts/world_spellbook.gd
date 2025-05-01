extends Control

class_name WorldSpellbook

signal book_closed

@onready var spellbook: Spellbook = $Spellbook2


func _ready() -> void:
	pass 
	
func instanciate_world_spellbook(spellbook_resource: SpellBookResource):
	spellbook.instanciate_spellbook(spellbook_resource)

func _on_back_to_game_pressed() -> void:
	spellbook.play_closing()
	await spellbook.opening_animation.animation_finished
	book_closed.emit()
	queue_free()
