extends Control

class_name Battle

signal battle_ended
signal player_won

@onready var textbox: Textbox = $Textbox
@onready var background: Background = $Background
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	State.paused = true
	add_to_group("active_battle")
	assert(player)
	assert(enemy)
	background.set_backgound(enemy.element)
	camera.make_current()
	
func start_battle() -> void:
	State.pause_everything()
	await player.spellbook.opening_animation.animation_finished
	textbox.battlestart(enemy.enemy_name)
	
func start_boss_battle() -> void:
	player.run_button.hide()
	enemy.enemy_resource.health /= 3
	enemy.enemy_resource.damage *= round(1.5)
	enemy.initialise_enemy()
	enemy.initialise_enemy()
	enemy.enemy_resource.health *= 3
	enemy.enemy_resource.damage /= round(1.5)
	await player.spellbook.opening_animation.animation_finished
	textbox.boss_battle_start(enemy.enemy_name)
	
func _on_textbox_start() -> void:
	enemy.battle_start()
	player.battle_start()
	
func end_of_battle(textbox_message:String) -> void:
	player.battle_end()
	textbox.display_text(textbox_message)
	await textbox.button.pressed
	State.paused = false
	await get_tree().create_timer(1).timeout
	
func _on_player_battle_lost() -> void:
	enemy.battle_end()
	await end_of_battle("You have lost")
	State.losses += 1
	State.current_health += round(State.max_health * 0.5)
	battle_ended.emit()
	queue_free()
	

func _on_enemy_battle_won() -> void:
	await end_of_battle("You have won!")
	State.wins += 1
	battle_ended.emit()
	player_won.emit()
	queue_free()


func _on_player_escape() -> void:
	textbox.display_text("You have escaped")
	await get_tree().create_timer(2).timeout
	battle_ended.emit()
	queue_free()
