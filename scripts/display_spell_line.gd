extends Control

class_name SpellLineDisplay

@onready var spell: SpellResource

@onready var label: Label = $Label
@onready var expbar: EXPbar = $ProgressBar



func _ready():
	if spell:
		spell.connect("proficiency_changed", _on_spell_proficiency_changed)
		update_display()

func _on_spell_proficiency_changed():
	update_display()

func update_display():
	label.text = str(spell.name.to_pascal_case()) + " Proficiency Lvl " + str(spell.proficiency_lvl)
	expbar.set_expirience(spell.proficiency_exp, spell.needed_exp)

func initialise_spell_line_display() -> void:
	label.text = str(spell.name.to_pascal_case()) + " Proficiency Lvl " + str(spell.proficiency_lvl)
	expbar.set_expirience(spell.proficiency_exp, spell.needed_exp)
