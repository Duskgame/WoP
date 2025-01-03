extends Node

class_name DamageComponent

func damage_multiplyer(player_element: int, enemy_element: int):
	var multiplyer: float = 1
	match player_element:
		0:
			multiplyer *= 1
		1:
			match enemy_element:
				0:
					multiplyer *=  1
				1:
					multiplyer *=  1
				2: 
					multiplyer *=  0.5
				3:
					multiplyer *=  2
		2:
			match enemy_element:
				0:
					multiplyer *=  1
				1:
					multiplyer *=  2
				2: 
					multiplyer *=  1
				3:
					multiplyer *=  0.5
		3:
			match enemy_element:
				0:
					multiplyer *=  1
				1:
					multiplyer *=  0.5
				2: 
					multiplyer *=  2
				3:
					multiplyer *=  1
	print("dmg multiplyer: " + str(multiplyer))
	return multiplyer
