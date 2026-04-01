extends Node3D

@onready var enemies = $Enemies.get_children()
@onready var barry :Node3D = $Barry
@onready var player: CharacterBody3D = $"3d_player"
@onready var text = $"Text Engine"
@onready var head = $"3d_player/Head"
@onready var cam = $"3d_player/Head/Camera3D"
@onready var music = $"3d_player/AudioStreamPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.stop()
	$AudioStreamPlayer.play()
	for enemy in enemies:
		enemy.jump_power = 0
	barry.myY = 50
	$"3d_player/Head/Camera3D".current = true
	await get_tree().create_timer(4.5).timeout
	player.can_move = false
	var move_down :Tween = create_tween()
	move_down.tween_property(barry,"myY",4.25,2)
	await move_down.finished
	text.write("Heya, kiddo! Y'know, you're doing a pretty good job getting through these levels.",Color(0.988, 1.0, 0.506, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("You again? What do you want?",Color(1.0, 1.0, 1.0, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Y'know, I want you to stop getting through these levels so fast. There are only so many, Y'know.",Color(0.988, 1.0, 0.506, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Why does he say 'Y'know' so much?",Color(0.593, 0.593, 0.593, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Heya, kiddo, it's just my thing.",Color(0.988, 1.0, 0.506, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Stop reading my thoughts! Stupid banana...",Color(1.0, 1.0, 1.0, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	text.write("I beg your pardon? That's it, kiddo. Bad luck.",Color(0.988, 1.0, 0.506, 1.0),0.08,1)
	while text.writing:
		await get_tree().process_frame
	var move_up :Tween = create_tween()
	move_up.tween_property(barry,"myY",50,2)
	await move_up.finished
	barry.queue_free()
	player.can_move = true
	for enemy in enemies:
		enemy.jump_power = 10.0
	music.play()
	$AudioStreamPlayer.stop()

func _on_dead_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.die()
	if body.is_in_group("Enemy"):
		body.squash()
	
func win():
	player.die()
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/3D Platformer/3d_platformer_2.tscn")
	
