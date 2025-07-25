extends Control

class_name Enemy

signal battle_won

@export var player: Player
@export var enemy_resource: EnemyResource

@onready var health_component: EnemyHealthComponent = $EnemyContainer/EnemyHealthComponent
@onready var enemy_texture: TextureRect = $EnemyContainer/Enemy
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_component: DamageComponent = $DamageComponent


var max_health: int 
var current_health: int 
var enemy_name: String 
var dmg: float
var regen: int 
var element: int
var attack_cooldown: float
var heal_cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialise_enemy()

func initialise_enemy() -> void:
	
	enemy_texture.texture = enemy_resource.texture
	max_health = enemy_resource.health * State.enemy_health_modifier
	current_health = max_health
	enemy_name = enemy_resource.name
	dmg = enemy_resource.damage * State.enemy_damage_modifier
	regen = enemy_resource.regeneration
	element = enemy_resource.element
	attack_cooldown = enemy_resource.attack_cooldown * State.enemy_speed_modifier
	heal_cooldown = enemy_resource.heal_cooldown * State.enemy_speed_modifier
	health_component.initialise_health(current_health,max_health, regen)


func battle_start() -> void:
	set_timer(attack_timer, attack_cooldown)
	set_timer(health_component.heal_timer, heal_cooldown)
	health_component.heal_timer.start()
	attack_timer.start()

func battle_end() -> void:
	health_component.heal_timer.stop()
	attack_timer.stop()

func set_timer(timer: Timer , base_time: float) -> void:
	timer.wait_time = base_time - (State.wins * State.win_modifier) + (State.losses * State.loss_modifier)

func _on_attack_timer_timeout() -> void:
	enemy_texture.attack_animation()
	#print(player.minions)
	if player.minions.size() > 0:
		var target_minion = player.minions[0]
		target_minion.take_damage(dmg)
	else:
		player.health_component.damage_health(dmg)
	
func _on_enemy_health_component_battle_won() -> void:
	battle_end()
	battle_won.emit()

func player_deal_damage(amount: float, player_element: int) -> void:
	enemy_texture.get_attacked_animation()
	amount *= damage_component.damage_multiplyer(player_element, enemy_resource.element)
	health_component.damage_health(amount)
	
func player_deal_calculated_damage(amount: float) -> void:
	enemy_texture.get_attacked_animation()
	health_component.damage_health(amount)


func _on_random_enemy_spawner_random_enemy(random_enemy: EnemyResource) -> void:
	enemy_resource = random_enemy
