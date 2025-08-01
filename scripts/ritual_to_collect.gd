extends Collectables

class_name RitualToCollect

signal ritual_learned(ritual: RitualResource)

#Needs to have Collectable Spells Scene as a parent

@onready var area: Area2D = $Area2D
@onready var collectables: Collectables = $"../"
@onready var label: Label = $Label

var ritual_to_collect: RitualResource
var collectable: bool = false
var player: player_body

func _ready() -> void:
	add_to_group(COLLECTABLE_RITUALS)
	assert(collectables, "Needs collectables as parent node")

	
func instanciate_ritual_to_collect():
	if len(collectables.possible_rituals) < 1:
		print("no valid rituals to learn ... deleting ritual to collect")
		queue_free()
	else:
		ritual_to_collect = get_ritual_to_collct()
		print(ritual_to_collect.name)

func _process(_delta: float) -> void:
	collect_ritual()

func get_ritual_to_collct() -> RitualResource:
	var ritual: RitualResource
	ritual = collectables.possible_rituals.pick_random()
	collectables.possible_rituals.erase(ritual)
	#print(collectable_spells.possible_spells)
	return ritual

func collect_ritual():
	if collectable:
		if Input.is_physical_key_pressed(KEY_F):
			player.spellbook.rituals.append(ritual_to_collect)
			player.save_spellbook_resource()
			#print(player.spellbook.spells)
			ritual_learned.emit(ritual_to_collect)
			queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player_body:
		player = body
		label.visible = true
		collectable = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player = null
	label.visible = false
	collectable = false
