extends Panel

@onready var spell_display = $VBoxContainer/ScrollContainer/VBoxContainer


func display_spells(spells: Array[SpellResource]):
	for spell in spells:
		var display = Label.new()
		display.theme = load("res://assets/fonts/themes/terminal_theme.tres")
		display.text = spell.name.to_pascal_case() + " Type: " + str(spell.TYPES.find_key(spell.type)).to_pascal_case()
		display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		spell_display.add_child(display)
	
