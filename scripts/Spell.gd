extends Resource

class_name SpellResource

signal proficiency_changed

@export var name : String

@export var proficiency_lvl: int = 1
@export var proficiency_exp: int = 0
@export var needed_exp: int = 10

var name_len = func():
	return float(len(name) * 0.5 * calc_proficiency_bonus())

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
	emit_signal("proficiency_changed")

func calc_needed_exp() -> int:
	return (proficiency_lvl ** 2 + proficiency_lvl) * 5
