extends Control

class_name RitualMiniGame

const CIRCLES = "circles"

@onready var center: Control = $Center
@onready var line: LineEdit = $Panel/LineEdit

var level: int = 7
var group: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_multiple_circles(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#rotate_circles(delta)

func create_circle(c_level: int):
	var texture: CircleTextureRect
	if c_level % 2 == 0:
		texture = TextureRight.new()
		texture.level = c_level
	else:
		texture = TextureLeft.new()
		texture.level = c_level
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.texture = load("res://assets/sprites/Miscelaneous/circle.png")
	texture.size = Vector2(120 + c_level * 70, 120 + c_level * 70)
	texture.pivot_offset = Vector2(texture.size / 2)
	texture.position = center.position - texture.pivot_offset
	texture.rotation = c_level * 10
	texture.add_to_group(CIRCLES)
	add_child(texture)

func create_multiple_circles(number_of_circles: int):
	for i in range(number_of_circles):
		create_circle(i)
	group = get_tree().get_nodes_in_group(CIRCLES)

func rotate_circles(delta):
	for node in group:
		print(node)
		if node is TextureRect:
			if int(node.pivot_offset.x) % 10 == 0:
				node.rotation += 0.1 * delta
			else:
				node.rotation -= 0.1 * delta



func _on_line_edit_text_submitted(new_text: String) -> void:
	for node in group:
		node as CircleTextureRect
		if new_text == str(node.level +1):
			node.rotating = true
	line.clear()
