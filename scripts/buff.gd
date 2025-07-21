extends Timer

class_name BuffTimer

var bonus: float 
var buff_type: float
var duration: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func start_buff_timer(bonus: float, buff_type: float, duration: float):
	self.bonus = bonus
	self.buff_type = buff_type
	self.duration = duration
	start(duration)
	buff_type *= bonus

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timeout() -> void:
	buff_type /= bonus
	queue_free()
