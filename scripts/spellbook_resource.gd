extends Resource

class_name SpellBookResource

@export var spells: Array[SpellResource]


func get_spell(spell_name: String) -> SpellResource:
	for spell in spells:
		if spell.name == spell_name:
			return spell
	return null

func update_spell(updated_spell: SpellResource):
	for i in range(spells.size()):
		if spells[i].name == updated_spell.name:
			spells[i] = updated_spell.duplicate_spell()
			break

func duplicate_spells() -> Array[SpellResource]:
	var duplicated_spells: Array[SpellResource] = []
	for spell in spells:
		duplicated_spells.append(spell.duplicate_spell())
	return duplicated_spells
