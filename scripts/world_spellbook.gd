extends Control

class_name WorldSpellbook

signal back_to_menu

@onready var spellbook: Spellbook = $Spellbook2


func _ready() -> void:
	pass 
	
func instanciate_world_spellbook(spellbook_resource: SpellBookResource):
	spellbook.instanciate_spellbook(spellbook_resource)

func _on_back_to_game_pressed() -> void:
	spellbook.play_closing()
	back_to_menu.emit()
	queue_free()
