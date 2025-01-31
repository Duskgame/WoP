extends Polygon2D

@onready var sibling = $"../CollisionPolygon2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = sibling.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
