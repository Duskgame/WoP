extends Panel

class_name RitualMessagePanel

signal closed

@onready var text_label: RichTextLabel = $RichTextLabel
@onready var button: Button = $AcceptButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_text("damage", 3 ,"damage", 30)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	closed.emit()
	queue_free()

func display_text(ritual_type: String, bonus: float, bonus_type: String, time: float):
	text_label.bbcode_enabled = true
	text_label.text = (
		"You have performed the Ritual of "
		+ str(ritual_type)
		+ "\n \n"
		+"you have gained +"
		+ str(bonus)
		+ "% "
		+ str(bonus_type)
		+ "\n \n"
		+ "For "
		+ str(time)
		+ " seconds"
	)
