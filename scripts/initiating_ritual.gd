extends Control

class_name RitualInitiation

signal ritual_started(ritual_instance: RitualMiniGame)

@onready var start_button: Button = $NextButton
@onready var level_slider: HSlider = $VBoxContainer/HBoxContainer/LevelSlider
@onready var needed_essences_label: Label = $VBoxContainer/HBoxContainer6/NeededEssences
@onready var fire_slider: HSlider = $VBoxContainer/HBoxContainer5/FireSlider
@onready var water_slider: HSlider = $VBoxContainer/HBoxContainer4/WaterSlider
@onready var ice_slider: HSlider = $VBoxContainer/HBoxContainer3/IceSlider
@onready var fire_label: RichTextLabel = $VBoxContainer/HBoxContainer5/FireLabel
@onready var water_label: RichTextLabel = $VBoxContainer/HBoxContainer4/WaterLabel
@onready var ice_label: RichTextLabel = $VBoxContainer/HBoxContainer3/IceLabel
@onready var speed_spin_box: SpinBox = $VBoxContainer/HBoxContainer2/SpeedSpinBox
@onready var parent = $"../../../"

var ritual_scene: PackedScene = preload("res://scenes/ritual_mini_game.tscn")
var ritual_minigame: RitualMiniGame

var ritual_type: Spells.RITUAL_TYPES = Spells.RITUAL_TYPES.STRENGHT

var needed_essences: int = 0 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ritual_minigame = ritual_scene.instantiate()
	start_button.text = ("Start Ritual of " + "\n" + str(Spells.RITUAL_TYPES.find_key(ritual_type)).to_pascal_case())
	set_level_slider_for_ritual(ritual_minigame)
	set_needed_essecence_label_with_level(level_slider.value)
	set_all_essece_slider()
	set_all_essence_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_level_slider_for_ritual(ritual: RitualMiniGame) -> void:
	level_slider.max_value = ritual.max_level
	level_slider.tick_count = level_slider.max_value

func set_essence_slider(slider: HSlider, essence: int):
	slider.max_value = essence
	slider.tick_count = slider.max_value + 1

func set_all_essece_slider() -> void:
	set_essence_slider(fire_slider, State.fire_essence)
	set_essence_slider(water_slider, State.water_essence)
	set_essence_slider(ice_slider, State.ice_essence)


func calc_needed_essences(current_level: int) -> void:
	var essences: int = 0
	for current in range(1, current_level + 1):
		essences += current + 4
	needed_essences = essences

func set_needed_essecence_label_with_level(level: int) -> void:
	calc_needed_essences(level)
	needed_essences_label.text = str(needed_essences)

func set_fire_essence_label(current_value: int):
	fire_label.bbcode_enabled = true
	fire_label.text = (
		"Fire Essence: "
		+ Spells.COLOR_FIRE_RED
		+ str(current_value)
		+ Spells.BBCODE_END_COLOR
		+ "/"
		+ Spells.COLOR_FIRE_RED
		+ str(State.fire_essence)
		+ Spells.BBCODE_END_COLOR
	)
	
func set_water_essence_label(current_value: int):
	water_label.bbcode_enabled = true
	water_label.text = (
		"Fire Essence: "
		+ Spells.COLOR_WATER_BLUE
		+ str(current_value)
		+ Spells.BBCODE_END_COLOR
		+ "/"
		+ Spells.COLOR_WATER_BLUE
		+ str(State.water_essence)
		+ Spells.BBCODE_END_COLOR
	)
	
func set_ice_essence_label(current_value: int):
	ice_label.bbcode_enabled = true
	ice_label.text = (
		"Fire Essence: "
		+ Spells.COLOR_ICE_BLUE
		+ str(current_value)
		+ Spells.BBCODE_END_COLOR
		+ "/"
		+ Spells.COLOR_ICE_BLUE
		+ str(State.ice_essence)
		+ Spells.BBCODE_END_COLOR
	)

func set_all_essence_labels():
	set_fire_essence_label(fire_slider.value)
	set_water_essence_label(water_slider.value)
	set_ice_essence_label(ice_slider.value)

func check_if_needed_essences_met():
	if fire_slider.value + water_slider.value + ice_slider.value >= needed_essences:
		start_button.disabled = false
	else:
		start_button.disabled = true

func _on_level_slider_value_changed(value: int) -> void:
	set_needed_essecence_label_with_level(value)
	check_if_needed_essences_met()


func _on_fire_slider_value_changed(value: int) -> void:
	set_fire_essence_label(value)
	check_if_needed_essences_met()

func _on_water_slider_value_changed(value: int) -> void:
	set_water_essence_label(value)
	check_if_needed_essences_met()

func _on_ice_slider_value_changed(value: int) -> void:
	set_ice_essence_label(value)
	check_if_needed_essences_met()


func _on_start_button_pressed() -> void:
	State.fire_essence -= fire_slider.value
	State.water_essence -= water_slider.value
	State.ice_essence -= ice_slider.value
	SaveSpellbook.save_state()
	ritual_minigame.level = level_slider.value
	ritual_minigame.speed_modifier = speed_spin_box.value
	parent.add_child(ritual_minigame)
	ritual_started.emit(ritual_minigame)
	queue_free()


func _on_back_button_pressed() -> void:
	queue_free()
