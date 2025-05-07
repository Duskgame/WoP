extends Resource

class_name SpellResource

signal proficiency_changed

@export var name : String

@export var proficiency_lvl: int = 1
@export var proficiency_exp: int = 0
@export var needed_exp: int = 10

var name_len = func():
	return ((get_char_worth(name) ** 1.2) * 0.5 * calc_proficiency_bonus())

func calc_proficiency_bonus() -> float:
	if proficiency_lvl == 1:
		return 1
	elif proficiency_lvl > 1:
		return (proficiency_lvl - 1) * 1.05
	else:
		return 0

func increase_proficiency() -> void:
	proficiency_exp += 1
	if proficiency_exp >= needed_exp:
		proficiency_lvl += 1
		proficiency_exp = 0
		needed_exp = calc_needed_exp()
	proficiency_changed.emit()

func calc_needed_exp() -> int:
	return (proficiency_lvl ** 2 + proficiency_lvl) * 5
	

func get_char_worth(string: String):
	string = string.to_lower()
	var worth: float
	for character in string:
		const very_low_use = 1.5
		const low_use = 1.2
		const medium_use = 1
		const high_use = 0.8
		const very_high_use = 0.5
		match character:
			"a": worth += very_high_use
			"b": worth += medium_use
			"c": worth += high_use
			"d": worth += high_use
			"e": worth += very_high_use
			"f": worth += medium_use
			"g": worth += medium_use
			"h": worth += medium_use
			"i": worth += very_high_use
			"j": worth += very_low_use
			"k": worth += very_low_use
			"l": worth += high_use
			"m": worth += high_use
			"n": worth += very_high_use
			"o": worth += very_high_use
			"p": worth += high_use
			"q": worth += very_low_use
			"r": worth += very_high_use
			"s": worth += very_high_use
			"t": worth += very_high_use
			"u": worth += high_use
			"v": worth += low_use
			"w": worth += low_use
			"x": worth += low_use
			"y": worth += medium_use
			"z": worth += very_low_use
	return worth
