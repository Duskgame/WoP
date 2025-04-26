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
var spell_page_array: Array = []
var spell_array: Array = []
var spellbook_resource: SpellBookResource
var current_page: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instanciate_spellbook(test_spellbook)
	
func instanciate_spellbook(current_spellbook_resource: SpellBookResource) -> void:
	opening_animation.frame = 0
	play_opening()
	await opening_animation.animation_finished
	spellbook_resource = current_spellbook_resource
	sort_spells_in_arrays()
	slice_spell_array_in_chunks()
	#print(spell_array)
	set_spell_array_to_lower()
	put_spells_in_dict()
	put_pages_in_spell_page_array()
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

func slice_spell_array_in_chunks():
	var new_spell_array: Array = [] 
	const chunk: int = 5
	for type_array: Array in spell_array:
		if len(type_array) > 5:
			var of_five: int = len(type_array) / chunk
			var remainder: int = len(type_array) % chunk
			var slice: int = 0
			#print(of_five)
			#print(remainder)
			while true:
				#slice the array (0,5),(5,10),(10,15)... 
				new_spell_array.append(type_array.slice(slice * chunk, (slice * chunk) + chunk))
				slice += 1
				if slice == of_five:
					break
			new_spell_array.append(type_array.slice(remainder * -1, len(type_array)))
		else:
			new_spell_array.append(type_array)
	#After complete loop replace original array with sliced array
	spell_array.clear()
	for array in new_spell_array:
		if len(array) > 0:
			spell_array.append(array)
	#print(spell_array)

func set_spell_array_to_lower() -> void:
	for type_array in spell_array:
		for spell: SpellResource in type_array:
			spell.name = spell.name.to_lower()
			#print(spell.name)

func play_opening() -> void:
		opening_animation.stop()
		opening_animation.sprite_frames.set_animation_loop("opening", false)
		opening_animation.play("opening")

func display_spells() -> void:
	display_pages(current_page)
	
func display_pages(current_page: int):
	left_page.add_child(spell_page_array[current_page -1])
	right_page.add_child(spell_page_array[current_page])
	
func remove_page(page: VBoxContainer):
	var chrildren = page.get_children()
	for child in chrildren:
		page.remove_child(child)

func remove_both_pages():
	remove_page(left_page)
	remove_page(right_page)

func put_pages_in_spell_page_array():
	for type_array in spell_array:
		var new_page: VBoxContainer = VBoxContainer.new()
		var array_number: int = spell_array.find(type_array)
		spell_page_array.append(display_spell_page(new_page,type_array))
	if len(spell_array) % 2 != 0:
		spell_page_array.append(VBoxContainer.new())
	print(spell_page_array)



			
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

func display_spell_page(page: VBoxContainer, array: Array) -> VBoxContainer:
	page.add_child(display_spell_type(array[0]))
	for spell: SpellResource in array:
		var spell_display = SpellLineDisplayScene.instantiate()
		spell_display.spell = spell
		page.add_child(spell_display)
	return page


func _on_next_button_pressed() -> void:
	if current_page + 2 < len(spell_page_array):
		current_page += 2
		print(current_page)
		remove_both_pages()
		display_pages(current_page)


func _on_previous_button_pressed() -> void:
	if current_page - 2 >= 1:
		current_page -= 2
		print(current_page)
		remove_both_pages()
		display_pages(current_page)
