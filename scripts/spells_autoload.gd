extends Node

var attack_spells = ["Ice", "Fire", "Fireball", "Iceshard", "Water", "Waterslash"]

var heal_spells = ["Heal", "Recovery", "Healing", "Balm"]

enum ELEMENTS {
	FIRE = 0,
	WATER = 1,
	ICE = 2
}

enum TYPES {
	HEALING = 0,
	DAMAGE = 1,
	SUMMONING = 2
}

func get_spell_name_color_by_element(spell: SpellResource) -> String:
	var name: String = spell.name.to_pascal_case()
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

func get_spell_type_color_name(spell: SpellResource) -> String:
	var type: String = str(Spells.TYPES.find_key(spell.type)).to_pascal_case()
	if spell.type == Spells.TYPES.HEALING:
		return "[color=#4ACF5F]" + type + "[/color]"
	elif spell.type == Spells.TYPES.DAMAGE:
		return "[color=#E63E3E]" + type + "[/color]"
	elif spell.type == Spells.TYPES.SUMMONING:
		return "[color=#B26FC7]" + type + "[/color]"
	else:
		printerr("Unexpected Spell Type", spell.type)
		return ""
