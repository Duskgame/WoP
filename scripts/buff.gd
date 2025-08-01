extends Timer

class_name BuffTimer

var bonus: float 
var type: int
var duration: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func start_buff_timer(buff_bonus: float, ritual_type: int, buff_duration: float):
	self.bonus = snappedf((0.01 * buff_bonus) + 1, 0.01)
	self.type = ritual_type
	self.duration = buff_duration
	self.one_shot = true
	start(duration)
	get_buff_type(type)
	#print(type)
	#print(State.damage_modifier)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(time_left)
	if time_left == 0:
		end_timer()

func get_buff_type(ritual: int):
	match ritual:
		Spells.RITUAL_TYPES.STRENGHT:
			State.damage_modifier *= bonus
		Spells.RITUAL_TYPES.VITALITY:
			State.max_health *= bonus
			State.current_health = State.max_health

func remove_buff(ritual: int):
	match ritual:
		Spells.RITUAL_TYPES.STRENGHT:
			State.damage_modifier /= bonus
		Spells.RITUAL_TYPES.VITALITY:
			State.max_health /= bonus

func end_timer():
	remove_buff(type)
	SaveSpellbook.save_state()
	self.queue_free()

func _on_timeout() -> void:
	end_timer()
