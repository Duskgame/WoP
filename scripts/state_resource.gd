extends Resource

class_name StateResource

@export var current_health: int
@export var max_health: int
@export var current_position: Vector2

@export var fire_essence: int
@export var water_essence: int
@export var ice_essence: int

@export var wins: float
@export var losses: float

@export var win_modifier: float
@export var loss_modifier: float

@export var damage_modifier: float

@export var enemy_damage_modifier: float
@export var enemy_speed_modifier: float
@export var enemy_health_modifier: float

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
	self.win_modifier = State.win_modifier
	self.loss_modifier = State.loss_modifier
	self.damage_modifier = State.damage_modifier
	self.enemy_damage_modifier = State.enemy_damage_modifier
	self.enemy_speed_modifier = State.enemy_speed_modifier
	self.enemy_health_modifier = State.enemy_health_modifier
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
	State.win_modifier = self.win_modifier
	State.loss_modifier = self.loss_modifier
	State.damage_modifier = self.damage_modifier
	State.enemy_damage_modifier = self.enemy_damage_modifier
	State.enemy_speed_modifier = self.enemy_speed_modifier
	State.enemy_health_modifier = self.enemy_health_modifier
	State.paused = self.enemy_health_modifier
