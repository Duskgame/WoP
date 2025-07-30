extends Resource

class_name RitualResource

@export var name: String = "Ritual of "
@export var type: Spells.RITUAL_TYPES

func duplicate_ritual() -> RitualResource:
	var new_ritual = RitualResource.new()
	new_ritual.name = self.name
	new_ritual.type = self.type
	return new_ritual
