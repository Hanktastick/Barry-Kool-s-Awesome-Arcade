extends Node2D

var sproingDie = 0
var spikeDie = 0

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("E"):
		$"Text Engine".write("Text Engine Test.")

func _on_die_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		body.die()
		



func win():
	$"2D Platformer Player".die()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://Scenes/3D Platformer/3d_platformer_1.tscn")
