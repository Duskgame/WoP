extends Node

class_name SaveManager

@onready var spellbook: SpellBook = $"../SpellBook"

var spellbook_path : String = "user://current_spellbook.tres"


func save_game():
	print("Attempting to save game...")
	print("Save path: " + ProjectSettings.globalize_path(spellbook_path))

	var save_spellbook: SpellBookResource = SpellBookResource.new()
	save_spellbook.spells = spellbook.spellbook.duplicate_spells()
	
	var result = ResourceSaver.save(save_spellbook, spellbook_path)
	if result == OK:
		print("Game saved successfully!")
		#print_spellbook_contents(save_spellbook)
	else:
		print("Failed to save game. Error code: ", result)

func load_game():
	if ResourceLoader.exists(spellbook_path):
		print("Save path: " + ProjectSettings.globalize_path(spellbook_path))
		var loaded_resource = ResourceLoader.load(spellbook_path, "", ResourceLoader.CACHE_MODE_REPLACE)
		if loaded_resource is SpellBookResource:
			spellbook.spellbook = loaded_resource
			spellbook.spells = loaded_resource.spells
			#print_spellbook_contents(spellbook.spellbook)
		else:
			print("Failed to load spellbook: Invalid resource type")
	else:
		print("No save file found")

func print_spellbook_contents(spellbook_resource: SpellBookResource):
	print("Spellbook contents:")
	for spell in spellbook_resource.spells:
		print(spell.name + " - Level: " + str(spell.proficiency_lvl) + ", EXP: " + str(spell.proficiency_exp))
