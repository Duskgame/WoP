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
	
	var spell_name = set_name_color(str(spell.name.to_pascal_case()))
	
	label.text = (
	spell_name 
	+ " Proficiency Lvl " 
	+ str(spell.proficiency_lvl)
	+ "\n Current " 
	+ str(Spells.TYPES.find_key(spell.type).to_pascal_case()) 
	+ ": " + str(snapped(spell.name_len.call(),0.1))
	) 
	expbar.set_expirience(spell.proficiency_exp, spell.needed_exp)

func initialise_spell_line_display() -> void:
	update_display()

func set_name_color(name:String) -> String:
	if spell.type == Spells.TYPES.HEALING:
		return "[color=#4ACF5F]" + name + "[/color]"
	elif spell.type == Spells.TYPES.DAMAGE or spell.type == Spells.TYPES.SUMMONING:
		match spell.element:
			Spells.ELEMENTS.FIRE:
				return "[color=#B33831]" + name + "[/color]"
			Spells.ELEMENTS.WATER:
				return "[color=#3D436F]" + name + "[/color]"
			Spells.ELEMENTS.ICE:
				return "[color=#5FCDE4]" + name + "[/color]"
			var foo:
				printerr("Unexpected State \"", foo, "\" is not in Spells Element")
				return ""
	else:
		printerr("Unexpected Spell Type", spell.type)
		return ""
