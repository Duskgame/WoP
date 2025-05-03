extends Panel

class_name Textbox

signal start

@onready var textbox = $"."
@onready var textboxtext = $TextboxText
@onready var button = $AcceptButton

func display_text(text) -> void:
	textbox.show()
	textboxtext.text = text

func battlestart(enemy_name: String) -> void:
	display_text("A wild %s has appeared! \n 
	Defend yourself! Or run away ... I'm not your boss" % enemy_name.to_upper())
	await button.pressed
	start.emit()

func boss_battle_start(enemy_name: String) -> void:
	display_text("You have entered the monster den 
	But this time there is no turning back.
	You have to fight the Alpha %s to survive" % enemy_name.to_upper())
	await button.pressed
	start.emit()

func _on_accept_button_pressed() -> void:
	textbox.hide()
	
