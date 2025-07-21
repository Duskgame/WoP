extends Panel

class_name RitualMessagePanel

signal closed

@onready var text_label: RichTextLabel = $RichTextLabel
@onready var button: Button = $AcceptButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#display_text("Strenght", 3 ,"Damage", 30)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	closed.emit()
	queue_free()

func display_text(ritual_type: String, bonus: float, bonus_type: String, time: float):
	text_label.bbcode_enabled = true
	text_label.text = (
		"You have performed the Ritual of "
		+ Spells.COLOR_DAMAGE_RED
		+ str(ritual_type)
		+ Spells.BBCODE_END_COLOR
		+ "\n \n"
		+"you have gained +"
		+ Spells.COLOR_DAMAGE_RED
		+ str(bonus)
		+ Spells.BBCODE_END_COLOR
		+ "% "
		+ Spells.COLOR_DAMAGE_RED
		+ str(bonus_type)
		+ Spells.BBCODE_END_COLOR
		+ "\n \n"
		+ "For "
		+ Spells.COLOR_DAMAGE_RED
		+ str(time)
		+ Spells.BBCODE_END_COLOR
		+ " seconds"
	)
