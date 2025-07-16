extends CircleTextureRect

class_name TextureRight

var speed: float = 0.05 

var level: int

var rotating = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation -= speed * level * delta
