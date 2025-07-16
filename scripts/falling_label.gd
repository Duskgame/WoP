extends Label

class_name FallingLabel

signal deleted(node: FallingLabel)

@onready var view_rect: Rect2 = get_viewport_rect()

var speed: float = 10
var level: int = 8

var characters = 'abcdefghijklmnopqrstuvwxyz'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme = load("res://assets/fonts/themes/menu_button.tres")
	add_theme_stylebox_override("normal", load("res://assets/fonts/styleboxes/button_normal.tres"))
	var number_of_chars: int = randi_range(ceil(level / 2) + 2,ceil(level / 2) + 4)
	text = generate_word(characters, number_of_chars)
	position = Vector2(randf_range(0 + view_rect.size.x * 0.0,0 + view_rect.size.x * 0.8),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.y += speed * level * 0.5 * delta
	if global_position.y > view_rect.size.y:
		deleted.emit(self)
		queue_free()


func generate_word(chars, length):
	var word: String = ""
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
