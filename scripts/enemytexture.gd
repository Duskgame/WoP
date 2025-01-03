extends TextureRect

func enemy_attack_animation():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0, 64), 0.05)
	tween.tween_property(self, "position", Vector2(0, 44), 0.05)
	
func get_attacked_animation():
	var tween = create_tween()
	tween.tween_property(self, "rotation", deg_to_rad(5), 0.1)
	tween.tween_property(self, "rotation", deg_to_rad(-5), 0.1)
	tween.tween_property(self, "rotation", deg_to_rad(0), 0.1)
