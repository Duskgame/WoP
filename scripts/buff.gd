extends Timer

class_name BuffTimer

var factor: float 
var modification: float
var duration: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start(duration)
	modification *= factor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timeout() -> void:
	modification /= factor
	queue_free()
