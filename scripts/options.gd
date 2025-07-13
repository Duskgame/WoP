extends Control

class_name Options

@onready var max_health_mod: SpinBox = $VBoxContainer/HBoxContainer3/PlayerMaxHealthModifier
@onready var damage_mod: SpinBox = $VBoxContainer/HBoxContainer/EnemyDamageModifier
@onready var speed_mod: SpinBox = $VBoxContainer/HBoxContainer2/EnemySpeedModifier
@onready var enemy_health_mod: SpinBox = $VBoxContainer/HBoxContainer4/EnemyHealthModifier
@onready var difficulty_button: OptionButton = $VBoxContainer/HBoxContainer5/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health_mod.value = State.max_health
	damage_mod.value = State.enemy_damage_modifier
	speed_mod.value = State.enemy_speed_modifier
	enemy_health_mod.value = State.enemy_health_modifier
	

func _on_enemy_damage_modifier_value_changed(value: float) -> void:
	State.enemy_damage_modifier = value


func _on_enemy_speed_modifier_value_changed(value: float) -> void:
	State.enemy_speed_modifier = value


func _on_player_max_health_modifier_value_changed(value: float) -> void:
	State.max_health = value



func _on_enemy_health_modifier_value_changed(value: float) -> void:
	State.enemy_health_modifier = value


func _on_back_to_menu_pressed() -> void:
	SaveSpellbook.save_state()
	await  get_tree().create_timer(1.5).timeout
	queue_free()


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			State.win_modifier = 0.05
			State.loss_modifier = 0.10
		1:
			State.win_modifier = 0.05
			State.loss_modifier = 0.05
		2:
			State.win_modifier = 0.10
			State.loss_modifier = 0.05
