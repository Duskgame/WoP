extends Control

class_name Battle

@onready var textbox: Textbox = $Textbox
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player)
	assert(enemy)
	textbox.battlestart(enemy.enemy_name)
	print("Wins: " + str(State.wins) + " / Losses: " + str(State.losses))
	
func _on_textbox_start() -> void:
	enemy.battle_start()
	player.battle_start()

func _on_player_battle_lost() -> void:
	enemy.battle_end()
	await end_of_battle("You have lost")
	State.losses += 1
	State.current_health += round(State.max_health * 0.5)
	get_tree().reload_current_scene()
	
	
func end_of_battle(textbox_message:String) -> void:
	player.battle_end()
	textbox.display_text(textbox_message)
	await textbox.button.pressed
	await get_tree().create_timer(1).timeout


func _on_enemy_battle_won() -> void:
	await end_of_battle("You have won!")
	State.wins += 1
	get_tree().reload_current_scene()


func _on_player_escape() -> void:
	textbox.display_text("You have escaped")
	await get_tree().create_timer(2).timeout
	get_tree().quit()
