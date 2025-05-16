extends SpellResource

class_name  HealSpellResource

@export var type = Spells.TYPES.HEALING

func duplicate_spell() -> HealSpellResource:
	var new_spell = HealSpellResource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.proficiency_bonus = self.proficiency_bonus
	new_spell.type = self.type
	return new_spell
