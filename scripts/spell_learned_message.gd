extends Control

@onready var label: RichTextLabel = $RichTextLabel
@export var spell_ex: SpellResource

var spell: SpellResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_text(spell_to_display: SpellResource):
	spell = spell_to_display
	var spell_name = Spells.get_spell_name_color_by_element(spell_to_display)
	#set_name_color(str(spell.name.to_pascal_case()))
	
	label.text = (
		"[center]"
		+"You have learned the "
		+ str(Spells.TYPES.find_key(spell.type))
		+" Spell: "
		+ spell_name
		+"[/center]"
		)
	await  get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(label, "modulate", Color(1, 1, 1, 0), 3.5)
	await  get_tree().create_timer(3).timeout
	queue_free()
	
func set_name_color(name_string: String) -> String:
	if spell.type == Spells.TYPES.HEALING:
		return "[color=#4ACF5F]" + name_string + "[/color]"
	elif spell.type == Spells.TYPES.DAMAGE or spell.type == Spells.TYPES.SUMMONING:
		match spell.element:
			Spells.ELEMENTS.FIRE:
				return "[color=#B33831]" + name_string + "[/color]"
			Spells.ELEMENTS.WATER:
				return "[color=#3D436F]" + name_string + "[/color]"
			Spells.ELEMENTS.ICE:
				return "[color=#5FCDE4]" + name_string + "[/color]"
			var foo:
				printerr("Unexpected State \"", foo, "\" is not in Spells Element")
				return ""
	else:
		printerr("Unexpected Spell Type", spell.type)
		return ""
