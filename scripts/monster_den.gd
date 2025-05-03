extends StaticBody2D

class_name MonsterDen

signal monster_spawned(monster: EnemyBody)
signal collectable_spell_spawned(collectable: SpellToCollect)

const ENEMIES_GROUP_NAME = "Enemies"
const PLAYER_GROUP_NAME = "Player"
const COLLECTABLE_SPELLS = "CollectableSpells"
const POSSIBLE_SPELLS = "PossibleSpells"
const spell_to_learn = preload("res://scenes/spell_to_collect.tscn")
const collectable_spells = preload("res://scenes/collectable_spells.tscn")


@export var possible_monster_to_spawn: Array[PackedScene]

@onready var SpawnArea: Area2D = $SpawnArea
@onready var SpawnPoint: Node2D = $SpawnPoint
@onready var SpawnTimer: Timer = $SpawnTimer
@onready var label: Label = $Label
@onready var parent = $"../"

var bodies_inside: Array
var player_inside: bool = false
var monster_to_spawn: PackedScene
var boss_monster: EnemyBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.hide()
	monster_to_spawn = possible_monster_to_spawn.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SpawnTimer.paused = State.paused
	if player_inside:
		start_boss_battle()

func start_boss_battle():
	if Input.is_physical_key_pressed(KEY_E):
		if get_tree().get_node_count_in_group("active_battle") == 0:
			var monster_instance: EnemyBody = monster_to_spawn.instantiate()
			add_child(monster_instance)
			boss_monster = monster_instance
			monster_spawned.emit(monster_instance)
			monster_instance.battle_component.start_boss_battle()
			monster_instance.battle_ended.connect(boss_battle_lost)
			monster_instance.battle_component.player_won.connect(boss_battle_won)
			

func boss_battle_won():
	
	if get_tree().get_nodes_in_group(POSSIBLE_SPELLS):
		var collectable_spells: CollectableSpells = get_tree().get_first_node_in_group(POSSIBLE_SPELLS)
		drop_spell_to_learn(collectable_spells)
	else:
		var new_possible_spells: CollectableSpells = collectable_spells.instantiate()
		parent.add_child(new_possible_spells)
		var player: player_body = get_tree().get_first_node_in_group(PLAYER_GROUP_NAME)
		new_possible_spells.remove_learned_spells(player.spellbook)
		drop_spell_to_learn(new_possible_spells)
	await get_tree().create_timer(0.005).timeout
	if boss_monster:
		boss_monster.queue_free()
	queue_free()

func drop_spell_to_learn(collectable_parent: CollectableSpells):
	var collectable_instance: SpellToCollect = spell_to_learn.instantiate()
	collectable_parent.add_child(collectable_instance)
	collectable_spell_spawned.emit(collectable_instance)
	collectable_instance.instanciate_spell_to_collect()
	collectable_instance.global_position = global_position

func boss_battle_lost():
		await get_tree().create_timer(0.005).timeout
		if boss_monster:
			boss_monster.queue_free()
		#print(State.paused)
	

func _on_spawn_timer_timeout() -> void:
	if len(bodies_inside) == 0:
		if len(get_tree().get_nodes_in_group(ENEMIES_GROUP_NAME)) < 20:
			var monster_instance: EnemyBody = monster_to_spawn.instantiate()
			add_child(monster_instance)
			monster_spawned.emit(monster_instance)
			monster_instance.global_position = SpawnPoint.global_position


func _on_spawn_area_body_entered(body: Node2D) -> void:
	if body is EnemyBody or body is player_body:
		bodies_inside.append(body)
	if body is player_body:
		label.show()
		player_inside = true
	print(bodies_inside)


func _on_spawn_area_body_exited(body: Node2D) -> void:
	bodies_inside.erase(body)
	if body is player_body:
		label.hide()
		player_inside = false
