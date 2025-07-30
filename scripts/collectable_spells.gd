extends Node2D

class_name Collectables

const COLLECTABLES = "Collectables"
const COLLECTABLE_SPELLS = "CollectableSpells"
const COLLECTABLE_RITUALS = "CollectableRituals"
@export var possible_spells: Array[SpellResource]
@export var possible_rituals: Array[RitualResource]

func free() -> void:
	add_to_group(COLLECTABLES)

func remove_learned_spells(spellbook_resource: SpellBookResource):
	for spell in spellbook_resource.spells:
		for possible_spell in possible_spells:
			if spell.name.to_lower() == possible_spell.name.to_lower():
				var index: int = possible_spells.find(possible_spell)
				possible_spells.pop_at(index)
				#print(possible_spell.name + " removed")
	for ritual in spellbook_resource.rituals:
		for possible_ritual in possible_rituals:
			if ritual.name.to_lower() == possible_ritual.name.to_lower():
				var index: int = possible_rituals.find(possible_ritual)
				possible_rituals.pop_at(index)
	for c_spell: SpellToCollect in get_tree().get_nodes_in_group(COLLECTABLE_SPELLS):
		c_spell.instanciate_spell_to_collect()
	for c_ritual: RitualToCollect in get_tree().get_nodes_in_group(COLLECTABLE_RITUALS):
		c_ritual.instanciate_ritual_to_collect()
