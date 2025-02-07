extends TextureRect

class_name Background

var fire = preload("res://assets/fire_background.tres")
var water =  preload("res://assets/water_background.tres")
var ice = preload("res://assets/ice_background.tres")

func set_backgound(enemy_element):
	if enemy_element == 0:
		texture = fire
	if enemy_element == 1:
		texture = water
	if enemy_element == 2:
		texture = ice
	
