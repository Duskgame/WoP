class_name TemporarySpell

var elements: Array[ElementSpellResource]
var base_damage: Array[BaseDamageSpellResource]
var base_heal: Array[BaseHealSpellResource]

var final_damage: float
var final_heal: float

func sort_spells(spells: Array[SpellResource]):
	for spell: SpellResource in spells:
		match spell.type:
			Spells.TYPES.ELEMENT:
				elements.append(spell)
			Spells.TYPES.BASEDAMAGE:
				base_damage.append(spell)
			Spells.TYPES.BASEHEAL:
				base_heal.append(spell)

func calculate_multiplyer(enemy_element: int) -> float:
	var multiplyer: float = 1
	if len(elements) > 0:
		for element_component in elements:
			multiplyer *= element_component.get_elemental_multiplyer(enemy_element)
	return multiplyer
	
func calculate_damage() -> float:
	if len(base_damage) > 0:
		var damage: float = 1
		for base_damage_component in base_damage:
			damage *= base_damage_component.get_base_damage()
		damage /= len(base_damage) ** 1.2
		return damage
	else:
		return 0
	
func calculate_heal() -> float:
	if len(base_heal) > 0:
		var heal: float = 1
		for base_heal_component in base_heal:
			heal *= base_heal_component.get_base_heal()
		heal /= len(base_heal) ** 1.2
		return heal
	else:
		return 0
	
func calculate_final_spell_effect(spells: Array[SpellResource], enemy_element: int):
	sort_spells(spells)
	var multiplyer: float = calculate_multiplyer(enemy_element)
	var damage: float = calculate_damage()
	var heal: float = calculate_heal()
	final_damage = multiplyer * damage
	final_heal = (1 / multiplyer) * heal
	
