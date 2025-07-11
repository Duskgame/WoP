extends ProgressBar

class_name HPbar

@onready var bar = $"."
@onready var text = $HPText


func set_health(health: float, max_health: float):
	bar.value = ceil(health)
	bar.max_value = max_health
	text.text = "HP: %d/%d" % [ceil(health),max_health]
