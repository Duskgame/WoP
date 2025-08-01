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
	var spell_type: String = str(Spells.TYPES.find_key(spell.type).to_pascal_case()) 
	var current_amount: String = ": " + str(snapped(spell.name_len.call(),0.1))
	
	if spell.type == Spells.TYPES.ELEMENT:
		spell_type = (
			Spells.get_element_color_code(spell.element)
			+ str(Spells.ELEMENTS.find_key(spell.element)).to_pascal_case()
			+ Spells.BBCODE_END_COLOR
			)
		current_amount = ": " + str(spell.proficiency_bonus)
	
	label.text = (
	spell_name
	+ " Lvl " 
	+ str(spell.proficiency_lvl)
	+ "\nCurrent " 
	+ spell_type
	+ current_amount
	) 
	expbar.set_expirience(spell.proficiency_exp, spell.needed_exp)

func initialise_spell_line_display() -> void:
	update_display()
