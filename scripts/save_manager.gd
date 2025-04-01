extends Node

class_name SaveManager

var spellbook_path : String = "user://current_spellbook.tres"


func save_spellbook_resource(spellbook_resource: SpellBookResource):
	print("Attempting to save spellbook...")
	#print("Save path: " + ProjectSettings.globalize_path(spellbook_path))

	var save_spellbook: SpellBookResource = SpellBookResource.new()
	save_spellbook.spells = spellbook_resource.duplicate_spells()
	
	var result = ResourceSaver.save(save_spellbook, spellbook_path)
	if result == OK:
		print("spellbook saved successfully!")
		#print_spellbook_contents(save_spellbook)
	else:
		print("Failed to save spellbook. Error code: ", result)

func load_spellbook_resource():
	if ResourceLoader.exists(spellbook_path):
		#print("Save path: " + ProjectSettings.globalize_path(spellbook_path))
		var loaded_resource = ResourceLoader.load(spellbook_path, "", ResourceLoader.CACHE_MODE_REPLACE)
		if loaded_resource is SpellBookResource:
			var loaded_spellbook_resource: SpellBookResource
			loaded_spellbook_resource = loaded_resource
			loaded_spellbook_resource.spells = loaded_resource.spells
			return loaded_spellbook_resource
			#print_spellbook_contents(spellbook.spellbook)
		else:
			print("Failed to load spellbook: Invalid resource type")
	else:
		print("No save file found")

func print_spellbook_contents(spellbook_resource: SpellBookResource):
	print("Spellbook contents:")
	for spell in spellbook_resource.spells:
		print(spell.name + " - Level: " + str(spell.proficiency_lvl) + ", EXP: " + str(spell.proficiency_exp))
