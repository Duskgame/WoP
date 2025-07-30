extends Label

class_name FallingLabel

signal deleted(node: FallingLabel)

@onready var view_rect: Rect2 = get_viewport_rect()

var speed: float = 20
var level: int = 8
var deleting_point: float

var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(deleting_point, "needs to be given global deleting point")
	theme = load("res://assets/fonts/themes/menu_button.tres")
	add_theme_stylebox_override("normal", load("res://assets/fonts/styleboxes/button_normal.tres"))
	var number_of_chars: int = randi_range(3, 3 + ceil(level / 2))
	text = generate_word(characters, number_of_chars)
	position = Vector2(randf_range(0 + view_rect.size.x * 0.0,0 + view_rect.size.x * 0.8),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.y += speed * delta
	if global_position.y > deleting_point :
		print("deleting falling label ")
		deleted.emit(self)
		queue_free()


func generate_word(chars, length):
	var word: String = ""
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
