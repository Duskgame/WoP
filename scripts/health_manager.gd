extends Control

class_name EnemyHealthComponent

signal battle_won

@onready var hpbar: ProgressBar = $HPBar
@onready var heal_timer: Timer = $HealTimer

var current_health: int = 0
var max_health: int = 0 
var regeneration: int = 0

	
# takes input to set health variables
func initialise_health(current: int, max: int, regen: int):
	hpbar.set_health(current,max)
	current_health = current
	max_health = max
	regeneration = regen
	

func _on_heal_timer_timeout() -> void:
	current_health = min(current_health + regeneration, max_health)
	hpbar.set_health(current_health, max_health)
	
func damage_health(amount: int):
	print("dmg: " + str(amount))
	current_health = max(current_health - amount, 0)
	hpbar.set_health(current_health, max_health)
	if current_health == 0:
		battle_won.emit()
