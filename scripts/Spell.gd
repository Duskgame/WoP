extends Resource

class_name SpellResource

@export var name : String
@export var type : TYPES
@export var element : ELEMENTS

var name_len = func():
	return int(len(name) / 2)


enum TYPES {
	HEALING = 0,
	DAMAGE = 1
}

enum ELEMENTS {
	NONE = 0,
	FIRE = 1,
	WATER = 2,
	ICE = 3
}
