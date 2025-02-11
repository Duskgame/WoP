extends Resource

class_name EnemyResource

@export var name: String = "Enemy"
@export var texture: Texture2D = null
@export var health: int = 20
@export var damage: int = 1
@export var speed: int = 200
@export var attack_cooldown: float = 1.5
@export var regeneration: int = 1
@export var heal_cooldown: float = 1.5
@export var element : Spells.ELEMENTS

func get_texture_polygon():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image())
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()))
	
	if polygons.size() > 0:
		return polygons[0]
