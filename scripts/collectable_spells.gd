extends Node2D

class_name CollectableSpells

const POSSIBLE_SPELLS = "PossibleSpells"
const COLLECTABLE_SPELLS = "CollectableSpells"
@export var possible_spells: Array[SpellResource]
@export var possibble_rituals: Array[RitualResource]

func free() -> void:
	add_to_group(POSSIBLE_SPELLS)

func remove_learned_spells(spellbook_resource: SpellBookResource):
	for spell in spellbook_resource.spells:
		for possible_spell in possible_spells:
			if spell.name.to_lower() == possible_spell.name.to_lower():
				var index: int = possible_spells.find(possible_spell)
				possible_spells.pop_at(index)
				#print(possible_spell.name + " removed")
	for c_spell: SpellToCollect in get_tree().get_nodes_in_group(COLLECTABLE_SPELLS):
		c_spell.instanciate_spell_to_collect()
