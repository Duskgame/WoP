extends Control

class_name Enemy

signal enemy_attack(damage: int)
signal battle_won

@onready var enemy: EnemyResource

@onready var health_component = $EnemyContainer/EnemyHealthComponent
@onready var enemy_texture: TextureRect = $EnemyContainer/Enemy
@onready var attack_timer: Timer = $AttackTimer
@onready var damage_component: DamageComponent = $DamageComponent

@onready var max_health: int = enemy.health
@onready var current_health: int = max_health
@onready var enemy_name: String = enemy.name
@onready var dmg: int = enemy.damage
@onready var regen: int = enemy.regeneration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_texture.texture = enemy.texture
	health_component.initialise_health(current_health,max_health, regen)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func battle_start():
	set_attacktimer()
	set_healtimer()
	health_component.heal_timer.start()
	attack_timer.start()

func battle_end():
	health_component.heal_timer.stop()
	attack_timer.stop()

func set_attacktimer():
	attack_timer.wait_time = enemy.attack_cooldown
	attack_timer.wait_time = attack_timer.wait_time - (State.wins * 0.05) + (State.losses * 0.05)

func set_healtimer():
	health_component.heal_timer.wait_time = enemy.heal_cooldown
	health_component.heal_timer.wait_time = health_component.heal_timer.wait_time - (State.wins * 0.05) + (State.losses * 0.05)
	

func _on_attack_timer_timeout() -> void:
	enemy_texture.enemy_attack_animation()
	enemy_attack.emit(dmg)
	
	
func _on_enemy_health_component_battle_won() -> void:
	battle_end()
	battle_won.emit()


func _on_player_deal_damage(amount: int, player_element: int) -> void:
	amount = amount * damage_component.damage_multiplyer(player_element, enemy.element)
	health_component.damage_health(amount)


func _on_random_enemy_spawner_random_enemy(random_enemy: EnemyResource) -> void:
	enemy = random_enemy
