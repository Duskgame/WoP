extends Node

class_name PlayerHealthComponent

signal battle_lost

@onready var hpbar: HPbar = $HPBar


var add_health = func(amount):
	return min(State.current_health + amount, State.max_health)

var substract_health = func(amount):
	return max(State.current_health - amount, 0)


func damage_health( amount: float, operation = substract_health):
	State.current_health = operation.call(amount)
	hpbar.set_health(State.current_health, State.max_health)
	if State.current_health <= 0:
		battle_lost.emit()
		
func heal_health(amount: float, operation = add_health):
	print("heal: " + str(amount))
	State.current_health = operation.call(amount)
	hpbar.set_health(State.current_health, State.max_health)
