extends Control

class_name SummonedMinion

signal minion_defeated

@export var enemy: Enemy

@export var minion: SummoningSpellResource

@onready var health_component: MinionHealthComponent = $VBoxContainer/MinionHealthComponent
@onready var texture: TextureRect = $VBoxContainer/TextureRect
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_component: DamageComponent = $DamageComponent

@onready var max_health: float = minion.health * minion.calc_proficiency_bonus()
@onready var current_health: float = max_health
@onready var dmg: float = minion.damage

func _ready() -> void:
	attack_timer.start()
	texture.texture = minion.texture
	health_component.initialise_health(current_health,max_health)
	
func _on_attack_timer_timeout() -> void:
	enemy.player_deal_damage(dmg * minion.calc_proficiency_bonus(), minion.element)	

func take_damage(amount: float):
	texture.get_attacked_animation()
	amount *= damage_component.damage_multiplyer(enemy.element, minion.element)
	health_component.damage_health(amount)
	
#enemy muss angriff auf minion switchen wenn minion den tree entert

func _on_minion_health_component_minion_defeated() -> void:
	minion_defeated.emit()
	self.queue_free()
