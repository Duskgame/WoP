extends Tree

@onready var spell_tree = $"."

const SpellLineDisplayScene = preload("res://scenes/battle/display_spell_line.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_tree.connect("item_selected", _on_spell_item_selected)
	
# Function to display spells in a Tree node
func display_spells_in_tree(spells: Array[SpellResource]):
	spell_tree.clear()  # Clear existing items
	var root = spell_tree.create_item()
	spell_tree.set_hide_root(true)

# Create main types (Healing, Damage, Summoning)
	var spell_types = {}
	for type in Spells.TYPES.values():
		var category: TreeItem = spell_tree.create_item(root)
		category.set_text(0, str(Spells.TYPES.find_key(type)).to_pascal_case())
		category.collapsed = true
		spell_types[type] = category
	
	# Add spells to their respective types
	for spell in spells:
		match spell.type:
			Spells.TYPES.HEALING, Spells.TYPES.SUMMONING:
				add_spell_to_tree(spell_types[spell.type], spell)
			Spells.TYPES.DAMAGE:
				var damage_spell = spell as DamageSpellResource
				var element_category = get_or_create_element_category(spell_types[Spells.TYPES.DAMAGE], damage_spell.element)
				add_spell_to_tree(element_category, spell)

# Helper function to get or create element spell_types for damage spells
func get_or_create_element_category(damage_category, element):
	for i in range(damage_category.get_child_count()):
		var child = damage_category.get_child(i)
		if child.get_text(0) == str(Spells.ELEMENTS.find_key(element)).to_pascal_case():
			return child
	
	var new_element_category = spell_tree.create_item(damage_category)
	new_element_category.set_text(0, str(Spells.ELEMENTS.find_key(element)).to_pascal_case())
	return new_element_category
	
# Function to add a single spell to the tree
func add_spell_to_tree(parent, spell: SpellResource):
	var spell_item: TreeItem = spell_tree.create_item(parent)
	spell_item.set_text(0, spell.name.to_pascal_case())
	spell_item.set_metadata(0, spell)  # Store the spell object for later use
	spell_item.collapsed = true
	var subchild: TreeItem = spell_item.create_child()
	subchild.set_text(0, "Lvl " + str(spell.proficiency_lvl) + " Exp: " + str(spell.proficiency_exp) + "/" + str(spell.needed_exp))
	
	
# Function to update the display of a single spell
func update_spell_display(spell: SpellResource):
	var root = spell_tree.get_root()
	update_spell_item_recursive(root, spell)

# Helper function to recursively search and update a spell item
func update_spell_item_recursive(item, spell: SpellResource):
	if item.get_metadata(0) == spell:
		item.set_text(0, spell.name.to_pascal_case())
		return true
	
	for i in range(item.get_child_count()):
		if update_spell_item_recursive(item.get_child(i), spell):
			return true
	
	return false

func _on_spell_item_selected():
	var selected_item = spell_tree.get_selected()
	var spell = selected_item.get_metadata(0)
	if spell:
		display_spell_details(spell)

# Function to display spell details (implement as needed)
func display_spell_details(spell: SpellResource):
	var spell_line_display = SpellLineDisplayScene.instantiate()
	
	pass
