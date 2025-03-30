extends Node

class_name SpellBook

signal use_spell(input: String)


@onready var spell_input: LineEdit = $SpellPanel/LineEdit
@export var spellbook: SpellBookResource
@export var player: Player
@onready var spell_dict = {}
@onready var spell_panel = $SpellPanel
@onready var spells = spellbook.spells

func instanciate_spellbook(spellbook_resource: SpellBookResource) -> void:
	spellbook = spellbook_resource
	spells = spellbook_resource.spells
	set_spell_array_names_to_lower()
	spell_panel.display_spells(spells)
	get_spells_in_dict()
	update_spells()

func update_spells() -> void:
	for spell in spellbook.spells:
		match spell.type:
			Spells.TYPES.DAMAGE:
				spell_dict[spell.name] = spell as DamageSpellResource
			Spells.TYPES.HEALING:
				spell_dict[spell.name] = spell as HealSpellRecource
			Spells.TYPES.SUMMONING:
				spell_dict[spell.name] = spell as SummoningSpellResource

func get_spells_in_dict() -> void:
	for spell:SpellResource in spells:
		spell_dict[spell.name] = spell


func update_spell(updated_spell: SpellResource):
	spellbook.update_spell(updated_spell)
	update_spells()

func set_spell_array_names_to_lower() -> void:
	for i in range(len(spells)):
		if spells[i].name.to_lower() != spells[i].name:
			spells[i].name = spells[i].name.to_lower()

func is_in_book(input: String) -> bool:
	for spell in spells:
		if spell.name == input.to_lower():
			return true
	return false

func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	if is_in_book(new_text):
		use_spell.emit(new_text)
	spell_input.clear()
