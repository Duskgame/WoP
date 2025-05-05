extends Node2D

class_name world

const ENEMIES_GROUP_NAME = "Enemies"
const COLLECTABLE_SPELLS = "CollectableSpells"
const POSSIBLE_SPELLS = "PossibleSpells"
const MONSTER_DEN = "MonsterDens"

@onready var player: player_body = $PlayerBody
@onready var camera: Camera2D = $Camera2D
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: Pause = $Camera2D/Pause
@onready var collectable_spells:CollectableSpells = $CollectableSpells


func _ready() -> void:
	player.instanciate_player_body()
	collectable_spells.remove_learned_spells(player.spellbook)
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

func _process(delta: float) -> void:
	camera.global_position = player.global_position 
	
func _on_battle_detected(battle: Battle):
	State.paused = true
	camera.global_position = battle.global_position
	audio.pitch_scale = 1.75 - (State.current_health / State.max_health)
	ui.hide()
	
func _on_battle_ended() -> void:
	State.paused = false
	audio.pitch_scale = 0.75
	ui.show()
	
func load_player_spellbook_resource():
	player.load_spellbook_resource()

func end_game():
		await get_tree().create_timer(1).timeout
		print("escape")
		queue_free()


func _on_spell_to_collect_spell_learned(spell: SpellResource) -> void:
	var message = preload("res://scenes/spell_learned_message.tscn")
	var message_instance = message.instantiate()
	camera.add_child(message_instance)
	message_instance.set_text(spell)


func _on_monster_den_monster_spawned(monster: EnemyBody) -> void:
		monster.connect("battle_detected", _on_battle_detected)
		monster.connect("battle_ended", load_player_spellbook_resource)
		monster.connect("battle_ended", _on_battle_ended)


func _on_monster_den_collectable_spell_spawned(collectable: SpellToCollect) -> void:
	collectable.spell_learned.connect(_on_spell_to_collect_spell_learned)
	print("ping")
