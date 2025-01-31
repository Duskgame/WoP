extends ProgressBar

class_name EXPbar

@onready var bar = $"."
@onready var text = $Label


func set_expirience(current: int, needed: int):
	bar.value = current
	bar.max_value = needed
	text.text = "Exp to next Lvl : %d/%d" % [current,needed]
