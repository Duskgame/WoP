extends Node2D

class_name world

const ENEMIES_GROUP_NAME = "Enemies"
const COLLECTABLES = "Collectables"
const COLLECTABLE_SPELLS = "CollectableSpells"
const COLLECTABLE_RITUALS = "CollectableRituals"
const MONSTER_DEN = "MonsterDens"

@onready var player: player_body = $PlayerBody
@onready var camera: Camera2D = $Camera2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: Pause = $Camera2D/Pause
@onready var collectables: Collectables = $CollectableSpells


func _ready() -> void:
	ui.connect("ritual_started", _on_ritual_started)
	player.instanciate_player_body()
	collectables.remove_learned_spells(player.spellbook)
	if len(get_tree().get_nodes_in_group(MONSTER_DEN)) > 0:
		for den: MonsterDen in get_tree().get_nodes_in_group(MONSTER_DEN):
			den.monster_spawned.connect(_on_monster_den_monster_spawned)
			den.collectable_spell_spawned.connect(_on_monster_den_collectable_spell_spawned)
	for enemy in get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME):
		enemy.connect("battle_detected", _on_battle_detected)
		enemy.connect("battle_ended", load_player_spellbook_resource)
		enemy.connect("battle_ended", _on_battle_ended)
	for spell: SpellToCollect in get_tree().get_nodes_in_group(COLLECTABLE_SPELLS):
		spell.spell_learned.connect(_on_spell_to_collect_spell_learned)
	for ritual: RitualToCollect in get_tree().get_nodes_in_group(COLLECTABLE_RITUALS):
		ritual.ritual_learned.connect(_on_ritual_to_collect_ritual_learned)
	State.paused = false

func _process(_delta: float) -> void:
	camera.global_position = player.global_position 
	
func _on_ritual_started(ritual_instance: RitualMiniGame):
	State.paused = true
	ritual_instance.ritual_ended.connect(_on_ritual_ended)
	add_child(ritual_instance)
	ui.hide()

func _on_ritual_ended():
	print("hi")
	ui.show()

func _on_battle_detected(battle: Battle):
	SaveSpellbook.save_state()
	State.paused = true
	#print(player.global_position)
	#print(battle.global_positiona)
	camera.global_position = battle.global_position
	audio.pitch_scale = 1.75 - (State.current_health / State.max_health)
	ui.hide()
	
func _on_battle_ended() -> void:
	SaveSpellbook.save_state()
	State.paused = false
	audio.pitch_scale = 0.75
	ui.show()
	
func load_player_spellbook_resource():
	player.load_spellbook_resource()

func end_game():
	SaveSpellbook.save_state()
	await get_tree().create_timer(1).timeout
	print("escape")
	queue_free()


func _on_spell_to_collect_spell_learned(spell: SpellResource) -> void:
	var message = preload("res://scenes/spell_learned_message.tscn")
	var message_instance = message.instantiate()
	camera.add_child(message_instance)
	message_instance.set_spell_text(spell)

func _on_ritual_to_collect_ritual_learned(ritual: RitualResource) -> void:
	var message = preload("res://scenes/spell_learned_message.tscn")
	var message_instance = message.instantiate()
	camera.add_child(message_instance)
	message_instance.set_ritual_text(ritual)

func _on_monster_den_monster_spawned(monster: EnemyBody) -> void:
		monster.connect("battle_detected", _on_battle_detected)
		monster.connect("battle_ended", load_player_spellbook_resource)
		monster.connect("battle_ended", _on_battle_ended)


func _on_monster_den_collectable_spell_spawned(collectable: SpellToCollect) -> void:
	collectable.spell_learned.connect(_on_spell_to_collect_spell_learned)
	print("ping")


func _input(event: InputEvent) -> void:
	const zoom_change:= Vector2(0.03, 0.03)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if camera.zoom > Vector2(1, 1) - zoom_change * 10:
				camera.zoom -= zoom_change
				camera.scale = Vector2(1,1) / camera.zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if camera.zoom < Vector2(1, 1) + zoom_change * 10:
				camera.zoom += zoom_change
				camera.scale = Vector2(1,1) / camera.zoom
