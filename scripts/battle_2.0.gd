extends Control

class_name Battle

@onready var textbox = $Textbox
@onready var player = $Player
@onready var enemy = $Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.battlestart(enemy.enemy_name)
	print("Wins: " + str(State.wins) + " / Losses: " + str(State.losses))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_textbox_start() -> void:
	enemy.battle_start()
	player.battle_start()


func _on_player_battle_lost() -> void:
	enemy.battle_end()
	await end_of_battle("You have lost")
	State.losses += 1
	State.current_health += State.max_health / 2
	get_tree().reload_current_scene()
	
	
func end_of_battle(textbox_message:String):
	player.battle_end()
	textbox.display_text(textbox_message)
	await textbox.button.pressed
	await get_tree().create_timer(1).timeout


func _on_enemy_battle_won() -> void:
	await end_of_battle("You have won!")
	State.wins += 1
	get_tree().reload_current_scene()
