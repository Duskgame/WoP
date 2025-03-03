extends Node
class_name SaveManager2

const SAVE_FILE = "user://game_save.tres"

var save_data: GameSaveData

func _ready():
	save_data = GameSaveData.new()

func save_game():
	var player = get_tree().get_first_node_in_group("Player")
	save_data.player_position = player.global_position
	save_data.player_health = State.current_health
	save_data.player_max_health = State.max_health
	save_data.wins = State.wins
	save_data.losses = State.losses
	save_data.spellbook = player.spellbook_resource.duplicate(true)
	save_data.world_state = save_world_state()

	var result = ResourceSaver.save(save_data, SAVE_FILE)
	if result == OK:
		print("Game saved successfully!")
	else:
		print("Failed to save game. Error code: ", result)

func load_game():
	if ResourceLoader.exists(SAVE_FILE):
		var loaded_data = ResourceLoader.load(SAVE_FILE) as GameSaveData
		if loaded_data:
			save_data = loaded_data
			apply_loaded_data()
		else:
			print("Failed to load save data")
	else:
		print("No save file found")

func apply_loaded_data():
	var player = get_tree().get_first_node_in_group("Player")
	player.global_position = save_data.player_position
	State.current_health = save_data.player_health
	State.max_health = save_data.player_max_health
	State.wins = save_data.wins
	State.losses = save_data.losses
	player.spellbook_resource = save_data.spellbook
	apply_world_state(save_data.world_state)

func save_world_state() -> Dictionary:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var enemy_data = []
	for enemy in enemies:
		enemy_data.append({
			"position": str(enemy.global_position),
			"resource": enemy.enemy_resource.resource_path
		})
	print("Saved enemy data: ", enemy_data)
	return {"enemies": enemy_data}

func apply_world_state(state: Dictionary):
	var world = get_tree().current_scene
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	
	if "enemies" in state:
		for enemy_data in state["enemies"]:
			var enemy_scene = load("res://scenes/enemy.tscn")
			var enemy = enemy_scene.instantiate()
			enemy.global_position = Vector2(enemy_data["position"])
			enemy.enemy_resource = load(enemy_data["resource"])
			world.add_child(enemy)
	else:
		print("No enemy data found in world state")
	
	print("Applied world state, enemy count: ", get_tree().get_nodes_in_group("enemies").size())

func update_after_battle(battle_won: bool, enemy_position: Vector2):
	if battle_won:
		save_data.world_state["enemies"] = save_data.world_state["enemies"].filter(func(e): return Vector2(e["position"]) != enemy_position)
	save_game()
