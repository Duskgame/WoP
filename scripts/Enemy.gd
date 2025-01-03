extends Resource

class_name EnemyResource

@export var name: String = "Enemy"
@export var texture: Texture2D = null
@export var health: int = 20
@export var damage: int = 1
@export var attack_cooldown: float = 1.5
@export var regeneration: int = 1
@export var heal_cooldown: float = 1.5
@export var element : ELEMENTS

enum ELEMENTS {
	NONE = 0,
	FIRE = 1,
	WATER = 2,
	ICE = 3
}
