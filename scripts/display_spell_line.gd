extends Control

class_name SpellLineDisplay

@onready var spell: SpellResource

@onready var label: RichTextLabel = $Label
@onready var expbar: EXPbar = $ProgressBar



func _ready():
	if spell:
		spell.connect("proficiency_changed", _on_spell_proficiency_changed)
		update_display()

func _on_spell_proficiency_changed():
	update_display()

func update_display() -> void:
	
	var spell_name: String = Spells.get_spell_name_color_by_element(spell)
	
	label.text = (
	spell_name 
	+ " Lvl " 
	+ str(spell.proficiency_lvl)
	+ "\n Current " 
	+ str(Spells.TYPES.find_key(spell.type).to_pascal_case()) 
	+ ": " + str(snapped(spell.name_len.call(),0.1))
	) 
	expbar.set_expirience(spell.proficiency_exp, spell.needed_exp)

func initialise_spell_line_display() -> void:
	update_display()
