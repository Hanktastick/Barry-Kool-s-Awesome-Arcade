extends Node


var song = 1

var lvl = 1
var bullet_damage
var HP = 3
func _process(delta: float) -> void:
	if lvl == 1:
		bullet_damage = 10
	elif lvl == 2:
		bullet_damage = 7.5
	elif lvl == 3:
		bullet_damage = 12
