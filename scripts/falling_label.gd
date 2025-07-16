extends Label

class_name FallingLabel

var speed: float = 10
var level: int = 8

var characters = 'abcdefghijklmnopqrstuvwxyz'
var number_of_chars: int = randi_range(3,6)
@onready var view_rect: Rect2 = get_viewport_rect()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme = load("res://assets/fonts/themes/menu_button.tres")
	add_theme_stylebox_override("normal", load("res://assets/fonts/styleboxes/button_normal.tres"))
	text = generate_word(characters, number_of_chars)
	position = Vector2(randf_range(0 + view_rect.size.x * 0.1,0 + view_rect.size.x * 0.7),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.y += speed * level * delta
	if global_position.y > view_rect.size.y:
		queue_free()


func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
