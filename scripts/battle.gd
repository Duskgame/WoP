extends Control

signal won_battle
signal lost_battle

@export var enemy: Resource = null

@onready var textbox = $Textbox
@onready var player_hp = $PlayerPanel/PlayerData/HPBar
@onready var enemy_hp = $EnemyContainer/HPBar
@onready var attacktimer = $EnemyContainer/Enemy/AttackTimer
@onready var healtimer = $EnemyContainer/Enemy/HealTimer
@onready var attack_label = $ActionPanel/HBoxContainer/AttackLabel/AttackKey
@onready var heal_label = $ActionPanel/HBoxContainer/HealLabel/HealKey
@onready var enemy_texture = $EnemyContainer/Enemy



var current_player_health = 0
var current_enemy_health = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.hide()
	display_text("A wild %s has appeared! \n 
	Defend yourself! Or run away ... I'm not your boss" % enemy.name.to_upper())
	
	scramble_attack_keys()
	scramble_heal_keys()
	
	set_attacktimer()
	set_healtimer()
	print(attacktimer.wait_time)

	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	set_health(player_hp, State.current_health, State.max_health)
	set_health(enemy_hp, enemy.health, enemy.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	

func set_attacktimer():
	attacktimer.wait_time = attacktimer.wait_time - (State.wins * 0.05) + (State.losses * 0.05)
	
func set_healtimer():
	healtimer.wait_time = attacktimer.wait_time * 2.5
	
func set_health(bar, health, max_health):
	bar.value = health
	bar.max_value = max_health
	bar.get_node("Label").text = "HP: %d/%d" % [health,max_health]
	

func display_text(text):
	textbox.show()
	$Textbox/Label.text = text
	
func end_of_battle(textbox_message:String):
	textbox.show()
	display_text(textbox_message)
	await $Textbox/Ticker.pressed
	await get_tree().create_timer(1).timeout
	

func scramble_attack_keys():
	InputMap.action_erase_events("Attack")
	var event = InputEventKey.new()
	var attack_keys = [KEY_Y,KEY_U,KEY_I,KEY_O,KEY_P,KEY_H,KEY_J,KEY_K,KEY_L,KEY_B,KEY_N,KEY_M]
	event.keycode = attack_keys.pick_random()
	InputMap.action_add_event("Attack",event)
	var new_key = InputMap.action_get_events("Attack")
	attack_label.text = "%s" % [OS.get_keycode_string(new_key[0].keycode)]
	
func scramble_heal_keys():
	InputMap.action_erase_events("Heal")
	var event = InputEventKey.new()
	var attack_keys = [KEY_Q,KEY_W,KEY_E,KEY_R,KEY_T,KEY_A,KEY_S,KEY_D,KEY_F,KEY_G,KEY_Z,KEY_X,KEY_C,KEY_V]
	event.keycode = attack_keys.pick_random()
	InputMap.action_add_event("Heal",event)
	var new_key = InputMap.action_get_events("Heal")
	heal_label.text = "%s" % [OS.get_keycode_string(new_key[0].keycode)]
	
func player_attack_animation():
			var tween = create_tween()
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(5), 0.1)
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(-5), 0.1)
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(0), 0.1)
	
	
func player_action():
	if not textbox.is_visible():
		if Input.is_action_just_released("Attack"):
			player_attack_animation()
			current_enemy_health = max(current_enemy_health - State.damage, 0)
			set_health(enemy_hp, current_enemy_health, enemy.health)
			scramble_attack_keys()
			if current_enemy_health <= 0:
				attacktimer.stop()
				healtimer.stop()
				won_battle.emit()
		if Input.is_action_just_released("Heal"):
			State.current_health = min(State.current_health + 1, State.max_health)
			set_health(player_hp, State.current_health, State.max_health)
			scramble_heal_keys()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		player_action()
		


func _on_ticker_pressed() -> void:
	if textbox.visible:
		textbox.hide()
		attacktimer.start()
		healtimer.start()

func _on_run_pressed() -> void:
	end_of_battle("You escaped")
	get_tree().quit()

func _on_won_battle() -> void:
	await end_of_battle("You have won!")
	State.wins += 1
	get_tree().reload_current_scene()

func _on_lost_battle() -> void:
	await end_of_battle("You have lost")
	State.losses += 1
	State.current_health += 5
	get_tree().reload_current_scene()

func enemy_attack_animation():
	var tween = create_tween()
	tween.tween_property(enemy_texture, "position", Vector2(0, 64), 0.05)
	tween.tween_property(enemy_texture, "position", Vector2(0, 44), 0.05)
	

func _on_attack_timer_timeout() -> void:
	enemy_attack_animation()
	State.current_health = max(State.current_health - enemy.damage, 0)
	set_health(player_hp, State.current_health, State.max_health)
	if State.current_health <=0:
		attacktimer.stop()
		healtimer.stop()
		lost_battle.emit()

func enemy_heal_animation():
	var tween = create_tween()
	tween.tween_property(enemy_texture, "color", Vector2(0, 64), 0.05)
	tween.tween_property(enemy_texture, "color", Vector2(0, 44), 0.05)

func _on_heal_timer_timeout() -> void:
	current_enemy_health = min(current_enemy_health + 1, enemy.health)
	set_health(enemy_hp, current_enemy_health, enemy.health)
