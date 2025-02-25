extends Control

class_name MenuBackground

@export var edge_repulsion_strength: float = 1.0
@export var edge_repulsion_distance: float = 1.0
@export var mouse_attraction_strength = 50
@export var mouse_attraction_radius = 100.0

@export var separation_weight: float = 3.0
@export var alignment_weight: float = 0.1
@export var cohesion_weight: float = 0.01


var key_particle = preload("res://scenes/key_particle.tscn")
var particles = []
const VALID_KEYS = {
	KEY_A: "A", KEY_B: "B", KEY_C: "C", KEY_D: "D", KEY_E: "E",
	KEY_F: "F", KEY_G: "G", KEY_H: "H", KEY_I: "I", KEY_J: "J",
	KEY_K: "K", KEY_L: "L", KEY_M: "M", KEY_N: "N", KEY_O: "O",
	KEY_P: "P", KEY_Q: "Q", KEY_R: "R", KEY_S: "S", KEY_T: "T",
	KEY_U: "U", KEY_V: "V", KEY_W: "W", KEY_X: "X", KEY_Y: "Y",
	KEY_Z: "Z"
}

func _input(event):
	if particles.size() <= 200:
		if event is InputEventKey and event.pressed:
			var key_text = VALID_KEYS.get(event.keycode)
			if key_text:
				spawn_particle(key_text)

func spawn_particle(key_text):
	var particle: KeyParticle = key_particle.instantiate()
	particle.initialize(key_text, Vector2(randf() * get_viewport_rect().size.x, randf() * get_viewport_rect().size.y))
	add_child(particle)
	particles.append(particle)

func get_random_key():
	var keys = VALID_KEYS.keys()
	var random_index = randi() % keys.size()
	return keys[random_index]

func _process(delta):
	for i in range(particles.size() - 1, -1, -1):
		var particle = particles[i]
		if is_instance_valid(particle) and particle.is_inside_tree():
			apply_flocking_behavior(particle)
		else:
			particles.remove_at(i)
			
func calculate_edge_repulsion(particle):
	var repulsion = Vector2.ZERO
	var viewport_size = get_viewport_rect().size
# Left edge
	if particle.position.x < edge_repulsion_distance:
		repulsion.x += (edge_repulsion_distance - particle.position.x) / edge_repulsion_distance
# Right edge
	if particle.position.x > viewport_size.x - edge_repulsion_distance:
		repulsion.x -= (particle.position.x - (viewport_size.x - edge_repulsion_distance)) / edge_repulsion_distance
# Top edge
	if particle.position.y < edge_repulsion_distance:
		repulsion.y += (edge_repulsion_distance - particle.position.y) / edge_repulsion_distance
# Bottom edge
	if particle.position.y > viewport_size.y - edge_repulsion_distance:
		repulsion.y -= (particle.position.y - (viewport_size.y - edge_repulsion_distance)) / edge_repulsion_distance
	
	return repulsion * edge_repulsion_strength

func calculate_mouse_attraction(particle):
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: Vector2 = mouse_pos - particle.position
	var distance = direction.length()
	
	if distance < mouse_attraction_radius:
		var strength: float = (1 - distance / mouse_attraction_radius) * mouse_attraction_strength
		return direction.normalized() * strength
	else:
		return Vector2.ZERO

func apply_flocking_behavior(particle):
	var separation = Vector2.ZERO
	var alignment = Vector2.ZERO
	var cohesion = Vector2.ZERO
	var total = 0

	for other in particles:
		if is_instance_valid(other) and other != particle:
			var distance = particle.position.distance_to(other.position)
			if distance < 50:
				separation += (particle.position - other.position).normalized() / distance
				alignment += other.velocity
				cohesion += other.position
				total += 1

	if total > 0:
		alignment /= total
		cohesion /= total
		cohesion = (cohesion - particle.position).normalized()
			
	var edge_repulsion = calculate_edge_repulsion(particle)
	var mouse_attraction = calculate_mouse_attraction(particle)

	particle.velocity += separation * separation_weight\
						+ alignment * alignment_weight\
						+ cohesion * cohesion_weight\
						+ edge_repulsion\
						+ mouse_attraction
	particle.velocity = particle.velocity.limit_length(50)  # Max speed


func _on_timer_timeout() -> void:
	if particles.size() <= 200:
		var event = InputEventKey.new()
		event.keycode = get_random_key()
		spawn_particle(event.as_text())
