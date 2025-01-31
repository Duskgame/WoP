extends Panel

@onready var spell_display = $VBoxContainer/TabContainer

const SpellLineDisplayScene = preload("res://scenes/battle/display_spell_line.tscn")

func display_type_tabs() -> Dictionary:
	var type_tabs = {}
	for type in Spells.TYPES.values():
		var tab = VBoxContainer.new()
		tab.add_theme_constant_override("separation", 5)
		tab.theme = load("res://assets/fonts/themes/terminal_theme.tres")
		tab.name = str(Spells.TYPES.find_key(type)).to_pascal_case()
		spell_display.add_child(tab)
		type_tabs[type] = tab
	return type_tabs

func display_element_tabs(parent_container: TabContainer) -> Dictionary:
	var element_tabs = {}
	for element in Spells.ELEMENTS.values():
		var tab = VBoxContainer.new()
		tab.add_theme_constant_override("separation", 5)
		tab.theme = load("res://assets/fonts/themes/terminal_theme.tres")
		tab.name = str(Spells.ELEMENTS.find_key(element)).to_pascal_case()
		parent_container.add_child(tab)
		element_tabs[element] = tab
	return element_tabs


func get_damage_tab_container(parent):
	var tab_container: TabContainer = TabContainer.new()
	tab_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tab_container.tab_alignment = TabBar.ALIGNMENT_CENTER
	tab_container.tabs_position = TabContainer.POSITION_BOTTOM
	parent.add_child(tab_container)
	return tab_container

func display_spells(spells: Array[SpellResource]):
	var type_tabs = display_type_tabs()
	
	var sorted_spells = {}
	for type in Spells.TYPES.values():
		sorted_spells[type] = []
	
	for spell in spells:
		sorted_spells[spell.type].append(spell)
	
	for type in sorted_spells.keys():
		match type:
			0:
				var tab = type_tabs[type]
				for spell: SpellResource in sorted_spells[type]:
					var display = SpellLineDisplayScene.instantiate()
					display.spell = spell
					tab.add_child(display)
					display.initialise_spell_line_display()
			1:
				var tab = type_tabs[type]
				
				var new_container = get_damage_tab_container(tab)
				
				var element_tabs = display_element_tabs(new_container)
				
				var sorted_damage_spells = {}
				for element  in Spells.ELEMENTS.values():
					sorted_damage_spells[element] = []
				
				for spell: DamageSpellResource in sorted_spells[1]:
					sorted_damage_spells[spell.element].append(spell)
					
				for element in sorted_damage_spells.keys():
					var element_tab = element_tabs[element]
					for spell in sorted_damage_spells[element]:
						var display = SpellLineDisplayScene.instantiate()
						display.spell = spell
						element_tab.add_child(display)
						display.initialise_spell_line_display()
			2:
				var tab = type_tabs[type]
				for spell: SpellResource in sorted_spells[type]:
					var display = SpellLineDisplayScene.instantiate()
					display.spell = spell
					tab.add_child(display)
					display.initialise_spell_line_display()
