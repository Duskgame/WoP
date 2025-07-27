extends Node

const COLOR_FIRE_RED = "[color=#B33831]"
const COLOR_WATER_BLUE = "[color=#3D436F]" 
const COLOR_ICE_BLUE = "[color=#5FCDE4]"
const COLOR_HEALING_GREEN = "[color=#4ACF5F]"
const COLOR_DAMAGE_RED = "[color=#E63E3E]"
const COLOR_SUMMONING_PURPLE = "[color=#B26FC7]"
const BBCODE_END_COLOR = "[/color]"

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
	SUMMONING = 2,
	ELEMENT = 3,
	BASEDAMAGE = 4,
	BASEHEAL = 5
}

enum RITUAL_TYPES {
	STRENGHT = 0,
	VITALITY = 1
}

func get_spell_name_color_by_element(spell: SpellResource) -> String:
	var name: String = spell.name.to_pascal_case()
	if spell.type == Spells.TYPES.HEALING:
		return COLOR_HEALING_GREEN + name + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.DAMAGE or spell.type == Spells.TYPES.SUMMONING:
		match spell.element:
			Spells.ELEMENTS.FIRE:
				return COLOR_FIRE_RED + name + BBCODE_END_COLOR
			Spells.ELEMENTS.WATER:
				return COLOR_WATER_BLUE + name + BBCODE_END_COLOR
			Spells.ELEMENTS.ICE:
				return COLOR_ICE_BLUE + name + BBCODE_END_COLOR
			var foo:
				printerr("Unexpected State \"", foo, "\" is not in Spells Element")
				return ""
	elif spell.type == Spells.TYPES.ELEMENT:
		match spell.element:
			Spells.ELEMENTS.FIRE:
				return COLOR_FIRE_RED + name + BBCODE_END_COLOR
			Spells.ELEMENTS.WATER:
				return COLOR_WATER_BLUE + name + BBCODE_END_COLOR
			Spells.ELEMENTS.ICE:
				return COLOR_ICE_BLUE + name + BBCODE_END_COLOR
			var foo:
				printerr("Unexpected State \"", foo, "\" is not in Spells Element")
				return ""
	elif spell.type == Spells.TYPES.BASEDAMAGE:
		return COLOR_DAMAGE_RED + name + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.BASEHEAL:
		return COLOR_HEALING_GREEN + name + BBCODE_END_COLOR
			
	else:
		printerr("Unexpected Spell Type", spell.type)
		return ""

func get_spell_type_color_name(spell: SpellResource) -> String:
	var type: String = str(Spells.TYPES.find_key(spell.type)).to_pascal_case()
	if spell.type == Spells.TYPES.HEALING:
		return COLOR_HEALING_GREEN + type + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.DAMAGE:
		return COLOR_DAMAGE_RED + type + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.SUMMONING:
		return COLOR_SUMMONING_PURPLE + type + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.ELEMENT:
		return COLOR_SUMMONING_PURPLE + type + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.BASEDAMAGE:
		return COLOR_DAMAGE_RED + type + BBCODE_END_COLOR
	elif spell.type == Spells.TYPES.BASEHEAL:
		return COLOR_HEALING_GREEN + type + BBCODE_END_COLOR
	else:
		printerr("Unexpected Spell Type", spell.type)
		return ""

func get_damage_element_name_color(spell: DamageSpellResource) -> String:
	var element: String = str(Spells.ELEMENTS.find_key(spell.element)).to_pascal_case()
	match spell.element:
		Spells.ELEMENTS.FIRE:
			return COLOR_FIRE_RED + element + " " + BBCODE_END_COLOR
		Spells.ELEMENTS.WATER:
			return COLOR_WATER_BLUE + element + " " + BBCODE_END_COLOR
		Spells.ELEMENTS.ICE:
			return COLOR_ICE_BLUE + element + " " + BBCODE_END_COLOR
		var foo:
			printerr("Unexpected State \"", foo, "\" is not in Spells Element")
			return ""

func get_element_essence_color(element_enum: int):
	var element: String = str(Spells.ELEMENTS.find_key(element_enum).to_pascal_case())
	var essence_string: String = " Essences: "
	match element_enum:
		Spells.ELEMENTS.FIRE:
			return COLOR_FIRE_RED + element + essence_string + BBCODE_END_COLOR
		Spells.ELEMENTS.WATER:
			return COLOR_WATER_BLUE + element + essence_string + BBCODE_END_COLOR
		Spells.ELEMENTS.ICE:
			return COLOR_ICE_BLUE + element + essence_string + BBCODE_END_COLOR
		var foo:
			printerr("Unexpected State \"", foo, "\" is not in Spells Element")
			return ""

func get_element_color_code(element_enum: int):
	match element_enum:
		Spells.ELEMENTS.FIRE:
			return COLOR_FIRE_RED
		Spells.ELEMENTS.WATER:
			return COLOR_WATER_BLUE
		Spells.ELEMENTS.ICE:
			return COLOR_ICE_BLUE
		var foo:
			printerr("Unexpected State \"", foo, "\" is not in Spells Element")
			return ""
