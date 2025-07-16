extends Control

class_name RitualMiniGame

const CIRCLES = "circles"
const LABEL = "label"

@onready var center: Control = $Center
@onready var line: LineEdit = $Panel/LineEdit
@onready var light: PointLight2D = $Center/PointLight2D

var level: int = 8
var max_level: int = 8
var speed_modifier: float = 1
var cleared_level: int = 0
var circle_group: Array
var label_group: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_multiple_circles(level)
	line.grab_focus()
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for current in range(1, level + 1):
		#crate_random_label(current)

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
	texture.size = calc_circle_size(c_level)
	texture.pivot_offset = Vector2(texture.size / 2)
	texture.position = center.position - texture.pivot_offset
	texture.rotation = c_level * 10
	texture.z_index = -1
	texture.self_modulate = Color("#ffffffa4")
	texture.add_to_group(CIRCLES)
	add_child(texture)

func calc_circle_size(c_level: int):
	var min_size: int = 120
	if level < max_level:
		var difference: int = max_level - level
		min_size += difference * (difference + 6) * 4
	# tested magic numbers for smooth growth
		var size_calc: int = min_size + ((c_level) * ((c_level) + 6 + (difference*2)) * 4) 
		return Vector2(size_calc, size_calc)
	var size_calc: int = min_size + c_level * (c_level + 6) * 4
	return Vector2(size_calc, size_calc)
	

func create_multiple_circles(number_of_circles: int):
	for i in range(1, number_of_circles + 1):
		create_circle(i)
	circle_group = get_tree().get_nodes_in_group(CIRCLES)



func _on_line_edit_text_submitted(new_text: String) -> void:
	for node in label_group:
		node as FallingLabel
		if new_text == str(node.text):
			var circle = get_current_circle(node.level)
			circle.process_mode = Node.PROCESS_MODE_ALWAYS
			circle.self_modulate = Color("#ffffffff")
			cleared_level += 1
			light.texture_scale += 1
			label_group.erase(node)
			node.queue_free()
			#node.material = load("res://assets/fonts/themes/light_outline.tres")
	line.clear()

func get_current_circle(c_level: int):
	for node in circle_group:
		node as CircleTextureRect
		if node.level == c_level:
			return node
		

func create_random_label(c_level: int):
	var label: FallingLabel = FallingLabel.new()
	label.level = c_level
	label.add_to_group(LABEL)
	add_child(label)

func start_game():
	for current in range(1, level + 1):
		create_random_label(current)
		label_group = get_tree().get_nodes_in_group(LABEL)
		await get_tree().create_timer(5 / (current * speed_modifier)).timeout
