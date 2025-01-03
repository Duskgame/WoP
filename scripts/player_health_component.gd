extends Node

class_name PlayerHealthComponent

signal battle_lost


var add_health = func(amount):
	return min(State.current_health + amount, State.max_health)

var substract_health = func(amount):
	return max(State.current_health - amount, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage_health(bar: ProgressBar, amount: int, operation = substract_health):
	State.current_health = operation.call(amount)
	bar.set_health(State.current_health, State.max_health)
	if State.current_health <= 0:
		battle_lost.emit()
		
func heal_health(bar: ProgressBar, amount: int, operation = add_health):
	State.current_health = operation.call(amount)
	bar.set_health(State.current_health, State.max_health)
