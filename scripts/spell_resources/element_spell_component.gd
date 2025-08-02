extends SpellResource

class_name ElementSpellResource

@export var type = Spells.TYPES.ELEMENT
@export var element : Spells.ELEMENTS

func duplicate_spell() -> ElementSpellResource:
	var new_spell = ElementSpellResource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.proficiency_bonus = self.proficiency_bonus
	new_spell.element = self.element
	new_spell.type = self.type
	return new_spell

func get_elemental_multiplyer(enemy_element: int):
	var multiplier: float = 1
	var weak: float = 0.5 / proficiency_bonus
	var neutral: float = 1
	var strong: float = 1.5 * proficiency_bonus
		
	match element:
		Spells.ELEMENTS.FIRE:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplier *=  neutral
				Spells.ELEMENTS.WATER: 
					multiplier *=  weak 
				Spells.ELEMENTS.ICE:
					multiplier *=  strong 
		Spells.ELEMENTS.WATER:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplier *=  strong
				Spells.ELEMENTS.WATER: 
					multiplier *=  neutral
				Spells.ELEMENTS.ICE:
					multiplier *=  weak
		Spells.ELEMENTS.ICE:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplier *=  weak
				Spells.ELEMENTS.WATER: 
					multiplier *=  strong
				Spells.ELEMENTS.ICE:
					multiplier *=  neutral
	#print("elemental multiplier: " + str(multiplier))
	return snapped(multiplier, 0.01)
