extends Panel

@onready var spell_tree = $VBoxContainer/Tree  # Reference to the Tree node in the scene

const SpellLineDisplayScene = preload("res://scenes/display_spell_line.tscn")  # Preload the SpellLineDisplay scene for instantiation

# Called when the node is added to the scene tree
func _ready():
	# Set up the Tree to display column titles
	spell_tree.set_column_titles_visible(true)
	spell_tree.set_column_title(0, "Spell")  # First column title
	spell_tree.set_column_title(1, "Proficiency")  # Second column title
	spell_tree.connect("item_selected",  _on_spell_selected)  # Connect the "item_selected" signal to handle user interactions

# Function to display spells in a hierarchical tree structure
func display_spells(spells: Array[SpellResource]):
	spell_tree.clear()  # Clear any existing items in the Tree
	var root = spell_tree.create_item()  # Create a root item (hidden by default)
	spell_tree.set_hide_root(true)  # Hide the root item for a cleaner display
	
	var type_items = {}  # Dictionary to store TreeItems for each spell type
	for type in Spells.TYPES.values():
		# Create a TreeItem for each spell type and add it as a child of the root
		var type_item = spell_tree.create_item(root)
		type_item.set_text(0, str(Spells.TYPES.find_key(type)).to_pascal_case())  # Set the type name (e.g., "Healing")
		type_items[type] = type_item  # Store the TreeItem in the dictionary
	
	for spell in spells:
		match spell.type:
			Spells.TYPES.HEALING, Spells.TYPES.SUMMONING:
			# Add Healing and Summoning spells directly under their respective type
				add_spell_to_tree(type_items[spell.type], spell)
			Spells.TYPES.DAMAGE:
				# For Damage spells, group them by element (e.g., Fire, Water)
				var damage_spell = spell as DamageSpellResource
				var element_item = ensure_element_item(type_items[Spells.TYPES.DAMAGE], damage_spell.element)
				add_spell_to_tree(element_item, spell)

# Ensure that an element (e.g., Fire, Water) has its own TreeItem under Damage spells
func ensure_element_item(damage_type_item, element):
	# Check if an element already has a TreeItem under Damage spells
	for i in range(damage_type_item.get_child_count()):
		var child = damage_type_item.get_child(i)
		if child.get_text(0) == str(Spells.ELEMENTS.find_key(element)).to_pascal_case():
			return child  # Return the existing TreeItem if found
	
	# If no TreeItem exists for this element, create a new one
	var new_element_item = spell_tree.create_item(damage_type_item)
	new_element_item.set_text(0, str(Spells.ELEMENTS.find_key(element)).to_pascal_case())  # Set the element name (e.g., "Fire")
	return new_element_item

# Add a single spell to the tree under a given parent item
func add_spell_to_tree(parent_item, spell: SpellResource):
	var spell_item = spell_tree.create_item(parent_item)  # Create a new TreeItem as a child of the parent
	spell_item.set_text(0, spell.name)  # Set the name of the spell in the first column
	# Set proficiency details (level and experience) in the second column
	spell_item.set_text(1, "Lvl " + str(spell.proficiency_lvl) + " (" + str(spell.proficiency_exp) + "/" + str(spell.needed_exp) + ")")
	spell_item.set_metadata(0, spell)  # Store the actual SpellResource object as metadata for later use


# Called when an item in the tree is selected
func _on_spell_selected():
	var selected_item = spell_tree.get_selected()  # Get the currently selected TreeItem
	var spell = selected_item.get_metadata(0)  # Retrieve the SpellResource stored as metadata
	if spell:
		print("Selected spell: ", spell.name)  # Print or process information about the selected spell
		# You can update other UI elements here to show more details about this spell (e.g., proficiency level or effects)
