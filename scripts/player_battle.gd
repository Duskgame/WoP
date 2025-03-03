extends Control

class_name Player

const SPELLBOOK = preload("res://scenes/battle/spell_book.tscn")

signal battle_lost
signal escape

@export var enemy: Enemy

@onready var health_component: PlayerHealthComponent = $PlayerPanel/PlayerDisplay/PlayerHealthComponent
@onready var spellbook: SpellBook = $SpellBook
@onready var spell_input: LineEdit = $SpellBook/SpellPanel/LineEdit
@onready var save_manager: SaveManager = $SaveManager


var minions: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")
	health_component.hpbar.set_health(State.current_health, State.max_health)
	save_manager.load_game()
	spellbook.instanciate_spellbook()

func battle_start():
	spell_input.editable = true
	spell_input.grab_focus()
	
func battle_end():
	for minion: SummonedMinion in minions:
		minion.queue_free()
	minions.clear()
	spell_input.editable = false
	spell_input.release_focus()
	save_manager.save_game()

func _on_run_pressed() -> void:
	save_manager.save_game()
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
	use_spell(spell)

func get_spell_proficiency(spell: SpellResource):
	spell.increase_proficiency()
	print(spell.name + " proficiency " + str(spell.proficiency_exp))
