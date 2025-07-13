extends Control

signal won_battle
signal lost_battle

@export var enemy: Resource = null

@onready var textbox = $Textbox
@onready var player_hp = $PlayerPanel/PlayerData/HPBar
@onready var enemy_hp = $CenterContainer/EnemyContainer/HPBar
@onready var attacktimer = $CenterContainer/EnemyContainer/Enemy/AttackTimer
@onready var healtimer = $CenterContainer/EnemyContainer/Enemy/HealTimer
@onready var enemy_texture = $CenterContainer/EnemyContainer/Enemy
@onready var healspell = $CenterContainer/VBoxContainer/Panel/VBoxContainer/HealSpell
@onready var attackspell1 = $CenterContainer/VBoxContainer/Panel/VBoxContainer/AttackSpell1
@onready var attackspell2 = $CenterContainer/VBoxContainer/Panel/VBoxContainer/AttackSpell2
@onready var line = $CenterContainer/VBoxContainer/Panel/VBoxContainer/LineEdit



var current_player_health = 0
var current_enemy_health = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.hide()
	display_text("A wild %s has appeared! \n 
	Defend yourself! Or run away ... I'm not your boss" % enemy.name.to_upper())
	
	set_attacktimer()
	set_healtimer()
	print(attacktimer.wait_time)
	
	set_heal_spells(healspell)
	set_attack_spells(attackspell1)
	set_attack_spells(attackspell2)

	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	set_health(player_hp, State.current_health, State.max_health)
	set_health(enemy_hp, enemy.health, enemy.health)
	enemy_texture.texture = enemy.texture
	
func set_attack_spells(attack_spell: Button):
	attack_spell.text = Spells.attack_spells.pick_random()
	Spells.attack_spells.erase(attack_spell.text)
	
func set_heal_spells(heal_spell: Button):
	heal_spell.text = Spells.heal_spells.pick_random()
	Spells.heal_spells.erase(heal_spell.text)

func set_attacktimer():
	attacktimer.wait_time = attacktimer.wait_time - (State.wins * State.win_modifier) + (State.losses * State.loss_modifier)
	
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
	line.editable = false
	textbox.show()
	Spells.heal_spells.append(healspell.text)
	Spells.attack_spells.append(attackspell1.text)
	Spells.attack_spells.append(attackspell2.text)
	display_text(textbox_message)
	await $Textbox/Ticker.pressed
	await get_tree().create_timer(1).timeout
	

func player_attack_animation():
			var tween = create_tween()
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(5), 0.1)
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(-5), 0.1)
			tween.tween_property(enemy_texture, "rotation", deg_to_rad(0), 0.1)
	
	
func player_action():
	if not textbox.is_visible():
		line.editable = true
		line.grab_focus()
	

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
	

func use_attack_spell(new_text: String):
	player_attack_animation()
	current_enemy_health = max(current_enemy_health - int(len(new_text)/ 2), 0)
	set_health(enemy_hp, current_enemy_health, enemy.health)
	if current_enemy_health <= 0:
			attacktimer.stop()
			healtimer.stop()
			won_battle.emit()

func use_heal_spell(new_text: String):
	State.current_health = min(State.current_health + int(len(new_text)/ 2), State.max_health)
	set_health(player_hp, State.current_health, State.max_health)

func _on_line_edit_text_submitted(new_text: String) -> void:
	print(new_text)
	if new_text == healspell.text.to_lower():
		use_heal_spell(new_text)
	if new_text == attackspell1.text.to_lower():
		use_attack_spell(new_text)
	if new_text == attackspell2.text.to_lower():
		use_attack_spell(new_text)
	
		
	line.clear()
		
		
