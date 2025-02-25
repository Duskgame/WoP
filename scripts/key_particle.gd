extends Label

class_name KeyParticle

var velocity:= Vector2.ZERO
var lifetime: float = 30.0

func initialize(key_text, pos):
	$".".text = key_text
	var rand_float = randf_range(0.0,1.0)
	var rand_color: Color = Color(rand_float,rand_float,rand_float)
	$".".add_theme_color_override("font_color", rand_color)
	position = pos
	velocity = Vector2(randf_range(-30.0,30.0),randf_range(-30.0,30.0))

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
