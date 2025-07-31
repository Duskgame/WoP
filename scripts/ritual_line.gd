extends HBoxContainer

class_name RitualSpellbookLine

signal ritual_started(ritual_instance: RitualMiniGame)

const instanciate_ritual = preload("res://scenes/initiating_ritual.tscn")

@onready var label: RichTextLabel = $RichTextLabel
@onready var parent: Spellbook = $"../../../../../"

var ritual: RitualResource = load("res://Resources/Rituals/strength.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = (
		Spells.get_ritual_type_color_name(ritual)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var instance: RitualInitiation = instanciate_ritual.instantiate()
	instance.ritual_type = ritual.type
	instance.connect("ritual_started", _on_ritual_started)
	parent.add_child(instance)

func _on_ritual_started(ritual_instance: RitualMiniGame):
	ritual_started.emit(ritual_instance)
