extends Node2D

const BATTLE = preload("res://scenes/battle/battle2.0.tscn")

@onready var player = $PlayerBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_body_battle_detected(enemy: EnemyBody) -> void:
	var battle = BATTLE.instantiate()
	battle.player.spellbook.spellbook = player.spellbook
	battle.enemy.enemy_resource = enemy.enemy_resource
	add_child(battle)
