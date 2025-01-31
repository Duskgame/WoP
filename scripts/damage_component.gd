extends Node

class_name DamageComponent

func damage_multiplyer(other_element: int, self_element: int):
	var multiplyer: float = 1
	match other_element:
		0:
			match self_element:
				0:
					multiplyer *=  1
				1: 
					multiplyer *=  0.5
				2:
					multiplyer *=  2
		1:
			match self_element:
				0:
					multiplyer *=  2
				1: 
					multiplyer *=  1
				2:
					multiplyer *=  0.5
		2:
			match self_element:
				0:
					multiplyer *=  0.5
				1: 
					multiplyer *=  2
				2:
					multiplyer *=  1
	return multiplyer
