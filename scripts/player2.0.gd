extends Control

class_name Player

signal deal_damage(amount: int, element: int)
signal battle_lost


@onready var hpbar: ProgressBar = $PlayerPanel/PlayerDisplay/HPBar
@onready var health_component: PlayerHealthComponent = $PlayerHealthComponent
@onready var spellbook: SpellBook = $SpellBook
@onready var spell_input: LineEdit = $SpellBook/SpellPanel/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hpbar.set_health(State.current_health, State.max_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func battle_start():
	spell_input.editable = true
	spell_input.grab_focus()
	
func battle_end():
	spell_input.editable = false
	spell_input.release_focus()

func _on_run_pressed() -> void:
	get_tree().quit()


func _on_enemy_enemy_attack(damage: int) -> void:
	health_component.damage_health(hpbar, damage)
	

func _on_player_health_component_battle_lost() -> void:
	battle_lost.emit()


func _on_line_edit_text_submitted(new_text: String) -> void:
	print(new_text)
	new_text = new_text.to_lower()
	if spellbook.is_in_book(new_text):
		var spell: SpellResource = spellbook.spell_dict[new_text]
		use_spell(spell)
		
	spell_input.clear()

func use_spell(spell: SpellResource):
	match spell.type:
		0:
			health_component.heal_health(hpbar, spell.name_len.call())
		1:
			deal_damage.emit(spell.name_len.call(), spell.element)
			
