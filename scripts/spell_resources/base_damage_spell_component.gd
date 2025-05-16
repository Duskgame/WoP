extends SpellResource

class_name BaseDamageSpellResource

@export var type = Spells.TYPES.BASEDAMAGE

func duplicate_spell() -> BaseDamageSpellResource:
	var new_spell = BaseDamageSpellResource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.proficiency_bonus = self.proficiency_bonus
	new_spell.type = self.type
	return new_spell
	
func get_base_damage() -> float:
	return name_len.call()
