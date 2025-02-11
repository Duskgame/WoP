extends Node

class_name MovementComponent

func handle_movement(speed: float, velocity: Vector2, sprite: Sprite2D) -> Vector2:
	
	var vertical_direction := Input.get_axis("ui_left", "ui_right")
	
	if vertical_direction:
		velocity.x = vertical_direction * speed
		if vertical_direction == -1:
			sprite.flip_h = false
			
		elif vertical_direction == 1:
			sprite.flip_h = true

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var horizontal_direction := Input.get_axis("ui_up", "ui_down")
	
	if horizontal_direction:
		velocity.y = horizontal_direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
		
	return velocity
