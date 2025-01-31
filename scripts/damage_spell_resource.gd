extends SpellResource

class_name DamageSpellResource

@export var element : Spells.ELEMENTS

@export var type = Spells.TYPES.DAMAGE

func duplicate_spell() -> DamageSpellResource:
	var new_spell = DamageSpellResource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.element = self.element
	new_spell.type = self.type
	return new_spell
