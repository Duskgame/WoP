extends SpellResource

class_name SummoningSpellResource

@export var element : Spells.ELEMENTS
@export var texture: Texture2D = null
@export var health: int = 20
@export var damage: float = 1
@export var attack_cooldown: float = 1.5

@export var type = Spells.TYPES.SUMMONING



func duplicate_spell() -> SummoningSpellResource:
	var new_spell = SummoningSpellResource.new()
	new_spell.name = self.name
	new_spell.proficiency_lvl = self.proficiency_lvl
	new_spell.proficiency_exp = self.proficiency_exp
	new_spell.needed_exp = self.needed_exp
	new_spell.proficiency_bonus = self.proficiency_bonus
	new_spell.element = self.element
	new_spell.texture = self.texture
	new_spell.health = self.health
	new_spell.damage = self.damage 
	new_spell.attack_cooldown = self.attack_cooldown
	new_spell.type = self.type
	
	return new_spell
