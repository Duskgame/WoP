extends Control

class_name EnemyHealthComponent

signal battle_won

@onready var hpbar: HPbar = $HPBar
@onready var heal_timer: Timer = $HealTimer

var current_health: float = 0
var max_health: float = 0 
var regeneration: float = 0
	
# takes input to set health variables
func initialise_health(current: float, max_hp: float, regen: float):
	hpbar.set_health(current,max_hp)
	current_health = current
	max_health = max_hp
	regeneration = regen
	

func _on_heal_timer_timeout() -> void:
	current_health = min(current_health + regeneration, max_health)
	hpbar.set_health(current_health, max_health)
	
func damage_health(amount: float):
	print("player dmg: " + str(amount))
	current_health = max(current_health - amount, 0)
	hpbar.set_health(current_health, max_health)
	if current_health == 0:
		battle_won.emit()
