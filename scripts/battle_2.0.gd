extends Control

class_name Battle

signal battle_ended(player_won: bool)
signal player_won

@onready var textbox: Textbox = $Textbox
@onready var background: Background = $Background
@onready var player: Player = $Player
@onready var enemy: Enemy = $Enemy
@onready var camera: Camera2D = $Camera2D

var player_spellbook: SpellBookResource
var enemy_resource: EnemyResource
var enemy_body: EnemyBody

func _ready() -> void:
	initialize(player.spellbook.spellbook_resource, enemy.enemy_resource, null)

func initialize(spellbook: SpellBookResource, enemy_res: EnemyResource, world_enemy: EnemyBody):
	player_spellbook = spellbook
	enemy_resource = enemy_res
	enemy_body = world_enemy

	# Set up the battle scene with the specific enemy data
	player.spellbook.spellbook_resource = player_spellbook
	enemy.enemy_resource = enemy_resource
	enemy.initialise_enemy()

	background.set_backgound(enemy.element)
	textbox.battlestart(enemy.enemy_name)

func start_battle():
	add_to_group("active_battle")
	camera.make_current()
	_on_textbox_start()
	
func _on_textbox_start() -> void:
	enemy.battle_start()
	player.battle_start()

func end_of_battle(textbox_message: String) -> void:
	player.battle_end()
	enemy.battle_end()
	textbox.display_text(textbox_message)
	await textbox.button.pressed
	await get_tree().create_timer(1).timeout

func _on_player_battle_lost() -> void:
	end_of_battle("You have lost")
	State.losses += 1
	State.current_health += round(State.max_health * 0.5)
	battle_ended.emit(false)
	end_battle()

func _on_enemy_battle_won() -> void:
	end_of_battle("You have won!")
	State.wins += 1
	battle_ended.emit(true)
	player_won.emit()
	end_battle()

func _on_player_escape() -> void:
	end_of_battle("You have escaped")
	battle_ended.emit(false)
	end_battle()

func end_battle():
	await get_tree().create_timer(1).timeout
	queue_free()
