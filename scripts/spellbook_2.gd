extends Control

class_name Spellbook

const SpellLineDisplayScene = preload("res://scenes/battle/display_spell_line.tscn")

@export var test_spellbook: SpellBookResource
@onready var opening_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_page: VBoxContainer = $Pages/MarginContainer/LeftPage
@onready var right_page: VBoxContainer = $Pages/MarginContainer2/RightPage
@onready var next_button: Button = $NextButton
@onready var previous_button: Button = $PreviousButton

var spell_dict: Dictionary = {}
var spell_page_dict: Dictionary = {}
var spell_array: Array = []
var spellbook_resource: SpellBookResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instanciate_spellbook(test_spellbook)
	
func instanciate_spellbook(current_spellbook_resource: SpellBookResource) -> void:
	opening_animation.frame = 0
	play_opening()
	await opening_animation.animation_finished
	spellbook_resource = current_spellbook_resource
	sort_spells_in_arrays()
	print(spell_array)
	set_spell_array_to_lower()
	put_spells_in_dict()
	print(spell_dict)
	display_spells()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#dict for easy access to spells
func put_spells_in_dict() -> void:
	for spell: SpellResource in spellbook_resource.spells:
		match spell.type:
			Spells.TYPES.DAMAGE:
				spell_dict[spell.name] = spell as DamageSpellResource
			Spells.TYPES.HEALING:
				spell_dict[spell.name] = spell as HealSpellRecource
			Spells.TYPES.SUMMONING:
				spell_dict[spell.name] = spell as SummoningSpellResource


#sort every spell into categorys
func sort_spells_in_arrays():
	var Heal_Array: Array = []
	var Fire_Array: Array = []
	var Water_Array: Array = []
	var Ice_Array: Array = []
	var Summoning_Array: Array = []
	for spell: SpellResource in spellbook_resource.spells:
		match spell.type:
			Spells.TYPES.HEALING:
				Heal_Array.append(spell)
			Spells.TYPES.DAMAGE:
				spell as DamageSpellResource
				match spell.element:
					Spells.ELEMENTS.FIRE:
						Fire_Array.append(spell)
					Spells.ELEMENTS.WATER:
						Water_Array.append(spell)
					Spells.ELEMENTS.ICE:
						Ice_Array.append(spell)
			Spells.TYPES.SUMMONING:
				Summoning_Array.append(spell)
	if Heal_Array.size() > 0:
		spell_array.append(Heal_Array)
	if Fire_Array.size() > 0:
		spell_array.append(Fire_Array)
	if Water_Array.size() > 0:
		spell_array.append(Water_Array)
	if Ice_Array.size() > 0:
		spell_array.append(Ice_Array)
	if Summoning_Array.size() > 0:
		spell_array.append(Summoning_Array)


func set_spell_array_to_lower() -> void:
	for type_array in spell_array:
		for spell: SpellResource in type_array:
			spell.name = spell.name.to_lower()
			print(spell.name)

func play_opening() -> void:
		opening_animation.stop()
		opening_animation.sprite_frames.set_animation_loop("opening", false)
		opening_animation.play("opening")

func display_spells() -> void:
	for type_array in spell_array:
		if spell_array.find(type_array) % 2 == 0:
			display_spell_page(left_page,type_array)
		else:
			display_spell_page(right_page, type_array)

			
func display_spell_type(spell: SpellResource) -> RichTextLabel:
	var type_label = RichTextLabel.new()
	type_label.bbcode_enabled = true
	if spell is DamageSpellResource:
		type_label.text = (
			Spells.get_damage_element_name_color(spell)
			+ Spells.get_spell_type_color_name(spell)
			+ "[color=#000000] Spells [/color]"
			)
	else:
		type_label.text = (
			Spells.get_spell_type_color_name(spell)
			+ "[color=#000000] Spells [/color]"
			)
	type_label.theme = preload("res://assets/fonts/themes/terminal_theme.tres")
	type_label.add_theme_font_size_override("normal_font_size", 30)
	type_label.fit_content = true
	type_label.custom_minimum_size.y = 30
	return type_label
	
func display_damage_element(spell: DamageSpellResource) -> RichTextLabel:
	var type_label = RichTextLabel.new()
	type_label.bbcode_enabled = true
	type_label.text = (
		Spells.get_damage_element_name_color(spell)
		+ "[color=#000000] Spells [/color]"
		)
	type_label.theme = preload("res://assets/fonts/themes/terminal_theme.tres")
	type_label.add_theme_font_size_override("normal_font_size", 30)
	type_label.fit_content = true
	type_label.custom_minimum_size.y = 30
	return type_label
	
func display_spell_page(page: VBoxContainer, array: Array) -> void:
	page.add_child(display_spell_type(array[0]))
	for spell: SpellResource in array:
		var spell_display = SpellLineDisplayScene.instantiate()
		spell_display.spell = spell
		page.add_child(spell_display)
