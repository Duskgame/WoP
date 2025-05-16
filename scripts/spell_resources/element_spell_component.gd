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
	var multiplyer: float = 1
	var weak: float = 0.5 / proficiency_bonus
	var neutral: float = 1
	var strong: float = 1.5 * proficiency_bonus
		
	match element:
		Spells.ELEMENTS.FIRE:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  neutral
				Spells.ELEMENTS.WATER: 
					multiplyer *=  weak 
				Spells.ELEMENTS.ICE:
					multiplyer *=  strong 
		Spells.ELEMENTS.WATER:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  strong
				Spells.ELEMENTS.WATER: 
					multiplyer *=  neutral
				Spells.ELEMENTS.ICE:
					multiplyer *=  weak
		Spells.ELEMENTS.ICE:
			match enemy_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  weak
				Spells.ELEMENTS.WATER: 
					multiplyer *=  strong
				Spells.ELEMENTS.ICE:
					multiplyer *=  neutral
	print("elemental multyplyer: " + str(multiplyer))
	return multiplyer
