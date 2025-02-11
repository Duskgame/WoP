extends Polygon2D

@onready var sibling = $"../CollisionPolygon2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = sibling.polygon
