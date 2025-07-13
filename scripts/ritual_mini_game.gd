extends Control

class_name RitualMiniGame

const CIRCLES = "circles"

@onready var center: Control = $Center


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(7):
		create_circle(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#rotate_circles(delta)

func create_circle(level: int):
	var texture: TextureRect
	if level % 2 == 0:
		texture= TextureRight.new()
	else:
		texture = TextureLeft.new()
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.texture = load("res://assets/sprites/Miscelaneous/circle.png")
	texture.size = Vector2(150 + level * 50, 150 + level * 50)
	texture.pivot_offset = Vector2(texture.size / 2)
	texture.position = center.position - texture.pivot_offset
	texture.rotation = level * 10
	texture.add_to_group(CIRCLES)
	add_child(texture)

func rotate_circles(delta):
	for node in get_tree().get_nodes_in_group(CIRCLES):
		print(node)
		if node is TextureRect:
			if int(node.pivot_offset.x) % 10 == 0:
				node.rotation += 0.1 * delta
			else:
				node.rotation -= 0.1 * delta
