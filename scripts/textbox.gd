extends Panel

signal start

@onready var textbox = $"."
@onready var textboxtext = $TextboxText
@onready var button = $AcceptButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func display_text(text):
	textbox.show()
	textboxtext.text = text

func battlestart(enemy_name: String):
	display_text("A wild %s has appeared! \n 
	Defend yourself! Or run away ... I'm not your boss" % enemy_name.to_upper())
	await button.pressed
	start.emit()

func _on_accept_button_pressed() -> void:
	textbox.hide()
	
