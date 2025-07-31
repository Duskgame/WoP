extends Control

class_name RitualMiniGame

const CIRCLES = "circles"
const LABEL = "label"

@onready var center: Control = $Center
@onready var line: LineEdit = $Panel/LineEdit
@onready var light: PointLight2D = $Center/PointLight2D
@onready var message: RitualMessagePanel = $MessagePanel

var ritual_type: Spells.RITUAL_TYPES = Spells.RITUAL_TYPES.STRENGHT
@export var level: int = 2
var max_level: int = 5
@export var speed_modifier: float = 1
var total_words: int
var cleared_words: int
var bonus: float
var circle_group: Array
var label_group: Array
var last_word: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	message.visible = false
	create_multiple_circles(level)
	line.grab_focus()
	start_game()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
	texture.z_index = 3
	texture.self_modulate = Color("#ffffffa4")
	texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture.add_to_group(CIRCLES)
	add_child(texture)

func calc_circle_size(c_level: int):
	var min_size: int = 240
	var level_addition: int = 6
	var level_multiplier: int = 7
	if level < max_level:
		var difference: int = max_level - level
		min_size += difference * (difference + level_addition) * level_multiplier
	# tested magic numbers for smooth growth
		var diff_calc: int = min_size + ((c_level) * ((c_level) + level_addition + (difference*2)) * level_multiplier) 
		return Vector2(diff_calc, diff_calc)
	var size_calc: int = min_size + c_level * (c_level + level_addition) * level_multiplier
	return Vector2(size_calc, size_calc)
	

func create_multiple_circles(number_of_circles: int):
	for i in range(1, min(number_of_circles + 1, max_level + 1)):
		create_circle(i)
	circle_group = get_tree().get_nodes_in_group(CIRCLES)



func _on_line_edit_text_submitted(new_text: String) -> void:
	for node:FallingLabel in label_group:
		if new_text.to_lower() == str(node.text.to_lower()):
			if check_if_last_label_in_lvl(node):
				var circle = get_current_circle(node.level)
				circle.process_mode = Node.PROCESS_MODE_ALWAYS
				circle.self_modulate = Color("#ffffffff")
				light.texture_scale += 1
			cleared_words += 1
			bonus += 1
			label_group.erase(node)
			node.queue_free()
			#node.material = load("res://assets/fonts/themes/light_outline.tres")
	line.clear()
	check_for_end()

func get_current_circle(c_level: int):
	for node: CircleTextureRect in circle_group:
		if node.level == c_level:
			return node


func check_if_last_label_in_lvl(node: FallingLabel):
	var count: int = label_group.filter(func(label: FallingLabel): return label.level == node.level).size()
	if count == 1:
		return true

func create_random_label(c_level: int):
	var label: FallingLabel = FallingLabel.new()
	label.level = c_level
	label.deleting_point = self.global_position.y + self.size.y
	label.deleted.connect(_on_falling_label_deleted)
	label.z_index = 4
	label.add_to_group(LABEL)
	total_words += 1
	add_child(label)

func start_game():
	for current in range(1, level + 1):
		for i in (current + 4):
			create_random_label(current)
			label_group = get_tree().get_nodes_in_group(LABEL)
			await get_tree().create_timer(2 / speed_modifier).timeout
		await get_tree().create_timer(current / speed_modifier).timeout
	last_word = true


func _on_falling_label_deleted(node: FallingLabel):
	bonus -= 0.1
	label_group.erase(node)
	check_for_end()

func get_buff_type(ritual: int):
	match ritual:
		Spells.RITUAL_TYPES.STRENGHT:
			return "Damage"
		Spells.RITUAL_TYPES.VITALITY:
			return "Vitality"


func end_game():
	line.editable = false
	if cleared_words == total_words:
		bonus *= max(snappedf((0.01 * level * level) + 1, 0.01), 0)
	await get_tree().create_timer(3).timeout
	var type: String = str(Spells.RITUAL_TYPES.find_key(ritual_type)).to_pascal_case()
	snappedf(bonus, 0.01)
	message.display_text(type ,bonus , get_buff_type(ritual_type), 30 * speed_modifier,cleared_words,total_words)
	message.visible = true
	message.button.grab_focus()
	create_buff_timer() 
	#print(cleared_words)

func check_for_end():
	if last_word:
		if label_group.is_empty():
			end_game()

func create_buff_timer():
	var buff_timer: BuffTimer = BuffTimer.new()
	State.add_child(buff_timer)
	buff_timer.start_buff_timer(bonus, ritual_type, 30 * speed_modifier)


func _on_message_panel_closed() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()
