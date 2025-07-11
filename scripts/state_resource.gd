extends Resource

class_name StateResource

@export var current_health: int
@export var max_health: int
@export var current_position: Vector2

@export var fire_essence: int
@export var water_essence: int
@export var ice_essence: int

@export var wins: float = 0
@export var losses: float = 0

@export var damage: int

@export var enemy_damage_modifyer: float
@export var enemy_speed_modifyer: float
@export var enemy_health_modifyer: float

@export var paused: bool

func get_state():
	self.current_health = State.current_health
	self.max_health = State.max_health
	self.current_position = State.current_position
	self.fire_essence = State.fire_essence
	self.water_essence = State.water_essence
	self.ice_essence = State.ice_essence
	self.wins = State.wins
	self.losses = State.losses
	self.damage = State.damage
	self.enemy_damage_modifyer = State.enemy_damage_modifyer
	self.enemy_speed_modifyer = State.enemy_speed_modifyer
	self.enemy_health_modifyer = State.enemy_health_modifyer
	self.paused = State.paused
	
func set_state():
	State.current_health = self.current_health
	State.max_health = self.max_health
	State.current_position = self.current_position
	State.fire_essence = self.fire_essence
	State.water_essence = self.water_essence
	State.ice_essence = self.ice_essence
	State.wins = self.wins
	State.losses = self.losses
	State.damage = self.damage
	State.enemy_damage_modifyer = self.enemy_damage_modifyer
	State.enemy_speed_modifyer = self.enemy_speed_modifyer
	State.enemy_health_modifyer = self.enemy_health_modifyer
	State.paused = self.enemy_health_modifyer
