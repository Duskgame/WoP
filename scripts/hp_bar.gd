extends ProgressBar

class_name HPbar

@onready var bar = $"."
@onready var text = $HPText


func set_health(health: float, max_health: float):
	bar.value = health
	bar.max_value = max_health
	text.text = "HP: %d/%d" % [health,max_health]
