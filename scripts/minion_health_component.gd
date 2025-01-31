extends Control

class_name MinionHealthComponent

signal minion_defeated

@onready var hpbar: HPbar = $HPBar

var current_health: float = 0
var max_health: float = 0 
	
# takes input to set health variables
func initialise_health(current: float, max_hp: float):
	hpbar.set_health(current,max_hp)
	current_health = current
	max_health = max_hp
	
func damage_health(amount: float):
	print("enemy dmg: " + str(amount))
	current_health = max(current_health - amount, 0)
	hpbar.set_health(current_health, max_health)
	if current_health == 0:
		minion_defeated.emit()
