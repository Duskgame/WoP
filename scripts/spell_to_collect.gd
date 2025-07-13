extends CollectableSpells

class_name SpellToCollect

signal spell_learned(spell: SpellResource)


#Needs to have Collectable Spells Scene as a parent

@onready var area: Area2D = $Area2D
@onready var collectable_spells: CollectableSpells = $"../"
@onready var label: Label = $Label

var spell_to_collect: SpellResource
var collectable: bool = false
var player: player_body

func _ready() -> void:
	add_to_group(COLLECTABLE_SPELLS)
	assert(collectable_spells, "Needs collectable spells as parent node")

	
func instanciate_spell_to_collect():
	if len(collectable_spells.possible_spells) < 1:
		print("no valid spells to learn ... deleting spell to collect")
		queue_free()
	else:
		spell_to_collect = get_spell_to_collct()
		print(spell_to_collect.name)

func _process(_delta: float) -> void:
	collect_spell()

func get_spell_to_collct() -> SpellResource:
	var spell: SpellResource
	spell = collectable_spells.possible_spells.pick_random()
	collectable_spells.possible_spells.erase(spell)
	#print(collectable_spells.possible_spells)
	return spell

func collect_spell():
	if collectable:
		if Input.is_physical_key_pressed(KEY_F):
			player.spellbook.spells.append(spell_to_collect)
			player.save_spellbook_resource()
			print(player.spellbook.spells)
			spell_learned.emit(spell_to_collect)
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
