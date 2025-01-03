extends Control

signal won_battle
signal lost_battle

@export var enemy: Resource = EnemyResource
@export var player: Resource = PlayerResource

@onready var textbox = $Textbox
@onready var player_hp = $PlayerPanel/PlayerData/HPBar
@onready var enemy_hp = $CenterContainer/EnemyContainer/HPBar
@onready var attacktimer = $CenterContainer/EnemyContainer/Enemy/AttackTimer
@onready var healtimer = $CenterContainer/EnemyContainer/Enemy/HealTimer
@onready var enemy_texture = $CenterContainer/EnemyContainer/Enemy
@onready var line = $CenterContainer/VBoxContainer/Panel/VBoxContainer/LineEdit
@onready var healcontainer = $CenterContainer/VBoxContainer/Panel/VBoxContainer/Panel/HSplitContainer/ScrollContainer/Healing
@onready var attackcontainer = $CenterContainer/VBoxContainer/Panel/VBoxContainer/Panel/HSplitContainer/ScrollContainer2/Attack


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
	
	fill_spellbook()
	
	current_player_health = player.current_health
	current_enemy_health = enemy.health
	
	set_health(player_hp, player.current_health, player.max_health)
	set_health(enemy_hp, enemy.health, enemy.health)
	enemy_texture.texture = enemy.texture
	
func set_attacktimer():
	attacktimer.wait_time = attacktimer.wait_time - (player.wins * 0.05) + (player.losses * 0.05)
	
func set_healtimer():
	healtimer.wait_time = attacktimer.wait_time * 2.5
	
func set_health(bar, health, max_health):
	bar.value = health
	bar.max_value = max_health
	bar.get_node("Label").text = "HP: %d/%d" % [health,max_health]
	
func fill_spellbook():
	for spell in Spells.heal_spells:
		var new_spell = Label.new()
		healcontainer.add_child(new_spell)
		new_spell.text = spell
		new_spell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	for spell in Spells.attack_spells:
		var new_spell = Label.new()
		attackcontainer.add_child(new_spell)
		new_spell.text = spell
		new_spell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func display_text(text):
	textbox.show()
	$Textbox/Label.text = text
	
func end_of_battle(textbox_message:String):
	line.editable = false
	textbox.show()
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
	await end_of_battle("You escaped")
	get_tree().quit()

func _on_won_battle() -> void:
	await end_of_battle("You have won!")
	player.wins += 1
	get_tree().reload_current_scene()

func _on_lost_battle() -> void:
	await end_of_battle("You have lost")
	player.losses += 1
	player.current_health += 5
	get_tree().reload_current_scene()

func enemy_attack_animation():
	var tween = create_tween()
	tween.tween_property(enemy_texture, "position", Vector2(0, 64), 0.05)
	tween.tween_property(enemy_texture, "position", Vector2(0, 44), 0.05)
	

func _on_attack_timer_timeout() -> void:
	enemy_attack_animation()
	player.current_health = max(player.current_health - enemy.damage, 0)
	set_health(player_hp, player.current_health, player.max_health)
	if player.current_health <=0:
		attacktimer.stop()
		healtimer.stop()
		lost_battle.emit()

func _on_heal_timer_timeout() -> void:
	current_enemy_health = min(current_enemy_health + 1, enemy.health)
	set_health(enemy_hp, current_enemy_health, enemy.health)
	

func _on_line_edit_text_submitted(new_text: String) -> void:
	print(new_text)
	
		
	line.clear()
		
		
