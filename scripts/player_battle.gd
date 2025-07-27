extends Control

class_name Player

signal battle_lost
signal escape

@export var enemy: Enemy
@export var spellbook_resource: SpellBookResource

@onready var health_component: PlayerHealthComponent = $PlayerPanel/PlayerDisplay/PlayerHealthComponent
@onready var spellbook: Spellbook = $Spellbook2
@onready var spell_input: LineEdit = $LineEdit
@onready var run_button: Button = $PlayerPanel/PlayerDisplay/Run


var minions: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.hpbar.set_health(State.current_health, State.max_health)
	spellbook_resource = SaveSpellbook.load_spellbook_resource()
	spellbook.instanciate_spellbook(spellbook_resource)

func battle_start():
	spell_input.editable = true
	spell_input.grab_focus()
	
func battle_end():
	for minion: SummonedMinion in minions:
		minion.queue_free()
	minions.clear()
	spell_input.editable = false
	spell_input.release_focus()
	SaveSpellbook.save_spellbook_resource(spellbook_resource)

func _on_run_pressed() -> void:
	SaveSpellbook.save_spellbook_resource(spellbook_resource)
	escape.emit()


func _on_player_health_component_battle_lost() -> void:
	battle_lost.emit()


func use_spell(spell: SpellResource):
	match spell.type:
		Spells.TYPES.HEALING:
			health_component.heal_health( spell.name_len.call())
		Spells.TYPES.DAMAGE:
			enemy.player_deal_damage(spell.name_len.call(), spell.element)
		Spells.TYPES.SUMMONING:
			summon_minion(spell)
			

func summon_minion(spell: SummoningSpellResource):
	var minion_scene: PackedScene = load("res://scenes/battle/summoned_minion.tscn")
	var new_minion: SummonedMinion = minion_scene.instantiate()
	new_minion.minion = spell
	new_minion.enemy = enemy
	add_child(new_minion)
	minions.append(new_minion)
	new_minion.minion_defeated.connect(_on_minion_defeated.bind(new_minion))
	
func _on_minion_defeated(minion: SummonedMinion):
	minions.erase(minion)

func _on_spell_book_use_spell(input: String) -> void:
	var spell: SpellResource = spellbook.spell_dict[input]
	get_spell_proficiency(spell)
	#use_spell(spell)
	spellbook.display_spells()




func get_spell_proficiency(spell: SpellResource):
	spell.increase_proficiency()
	#print(spell.name + " proficiency " + str(spell.proficiency_exp))


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.to_lower()
	var word_array = new_text.split(" ")
	var spell_array: Array[SpellResource]
	for word in word_array:
		if is_in_book(word):
			_on_spell_book_use_spell(word)
			spell_array.append(get_spell(word))
	if len(spell_array) > 0:
		#print(spell_array)
		var temporary_spell: TemporarySpell = TemporarySpell.new()
		temporary_spell.calculate_final_spell_effect(spell_array,enemy.element)
		health_component.heal_health(temporary_spell.final_heal)
		enemy.player_deal_calculated_damage(temporary_spell.final_damage)
	spell_input.clear()


func get_spell(input: String):
	for spell in spellbook_resource.spells:
		if spell.name == input.to_lower():
			return spell

func is_in_book(input: String) -> bool:
	for spell in spellbook_resource.spells:
		if spell.name == input.to_lower():
			return true
	return false
