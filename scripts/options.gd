extends Control

class_name Options

@onready var max_health_mod: SpinBox = $"VBoxContainer/HBoxContainer3/Player Max Health Modifyer"
@onready var damage_mod: SpinBox = $VBoxContainer/HBoxContainer/EnemyDamageModifyer
@onready var speed_mod: SpinBox = $VBoxContainer/HBoxContainer2/EnemySpeedModifyer
@onready var enemy_health_mod: SpinBox = $VBoxContainer/HBoxContainer4/EnemyHealthModifyer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health_mod.value = State.max_health
	damage_mod.value = State.enemy_damage_modifyer
	speed_mod.value = State.enemy_speed_modifyer
	enemy_health_mod.value = State.enemy_health_modifyer
	

func _on_enemy_damage_modifyer_value_changed(value: float) -> void:
	State.enemy_damage_modifyer = value


func _on_enemy_speed_modifyer_value_changed(value: float) -> void:
	State.enemy_speed_modifyer = value


func _on_player_max_health_modifyer_value_changed(value: float) -> void:
	State.max_health = value



func _on_enemy_health_modifyer_value_changed(value: float) -> void:
	State.enemy_health_modifyer = value


func _on_back_to_menu_pressed() -> void:
	await  get_tree().create_timer(1.5).timeout
	queue_free()
