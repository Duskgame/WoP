extends Node

class_name DamageComponent

func damage_multiplyer(other_element: int, self_element: int):
	var multiplyer: float = 1
	match other_element:
		Spells.ELEMENTS.FIRE:
			match self_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  1
				Spells.ELEMENTS.WATER: 
					multiplyer *=  0.5
				Spells.ELEMENTS.ICE:
					multiplyer *=  2
		Spells.ELEMENTS.WATER:
			match self_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  2
				Spells.ELEMENTS.WATER: 
					multiplyer *=  1
				Spells.ELEMENTS.ICE:
					multiplyer *=  0.5
		Spells.ELEMENTS.ICE:
			match self_element:
				Spells.ELEMENTS.FIRE:
					multiplyer *=  0.5
				Spells.ELEMENTS.WATER: 
					multiplyer *=  2
				Spells.ELEMENTS.ICE:
					multiplyer *=  1
	return multiplyer
