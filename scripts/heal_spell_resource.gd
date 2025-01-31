extends SpellResource

class_name  HealSpellRecource

@export var type = Spells.TYPES.HEALING

func duplicate_spell() -> HealSpellRecource:
	var new_spell = HealSpellRecource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.type = self.type
	return new_spell
