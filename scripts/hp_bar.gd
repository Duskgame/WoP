extends ProgressBar

@onready var bar = $"."
@onready var text = $HPText


func set_health(health: int, max_health: int):
	bar.value = health
	bar.max_value = max_health
	text.text = "HP: %d/%d" % [health,max_health]
