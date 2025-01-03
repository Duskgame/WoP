extends Node

class_name SpellBook

@export var spells: Array[SpellResource]

@onready var spell_dict = {}

@onready var spell_panel = $SpellPanel

func _ready() -> void:
	set_spell_array_names_to_lower()
	spell_panel.display_spells(spells)
	get_spells_in_dict()
	
func get_spells_in_dict():
	for spell:SpellResource in spells:
		spell_dict[spell.name] = spell

func set_spell_array_names_to_lower():
	for i in range(len(spells)):
		if spells[i].name.to_lower() != spells[i].name:
			spells[i].name = spells[i].name.to_lower()

func is_in_book(input: String) -> bool:
	for spell in spells:
		if spell.name == input.to_lower():
			return true
	return false
