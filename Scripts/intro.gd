extends Node3D

@onready var player = $"3d_player"
@onready var white = $CanvasLayer/ColorRect2
@onready var e = $CanvasLayer/ColorRect
@onready var light = $"Arcade/Arcade Machine Light"
@onready var screen = $"Arcade/Screen"

var platformer1 = "res://Scenes/2D Platformer/2d_platformer_1.tscn"

func _ready() -> void:
	white.modulate.a = 0.0
	$"Text Engine".write("Alright, let's check this place out...", Color(1.0, 1.0, 1.0, 1.0), 0.075, 2)
	
	


func _process(_delta: float) -> void:
	
	player.SPEED = 1
	player.scale.y = 2
	light.light_energy = randf_range(1.5,3.5)
	player.speed_cap = 5
	player.used_double_jump = true
	
	var distance = player.global_position.distance_to(screen.global_position)
	if distance < 5:
		var t = clamp((distance - 1.0) / (5 - 1.0), 0.0, 1.0)
		e.modulate.a = lerp(2.0, 0.0, t)
	else:
		e.modulate.a = 0
	
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		
		
		while not Input.is_action_just_pressed("E"):
			await get_tree().process_frame
		
		player.can_move = false
		player.can_rotate_head = false
		var tween = create_tween()
		tween.tween_property(e, "modulate:a", 0, 0.25)
		await tween.finished
		player.global_position = Vector3(0.0,2.31,7.0)
		
		$"3d_player"/Head.rotation_degrees = Vector3(0,180,0)
		$"3d_player"/Head/Camera3D.rotation_degrees = Vector3(0,0,0)
		e.visible = false
		
		tween = create_tween()
		var fov = create_tween()
		fov.tween_property($"3d_player"/Head/Camera3D, "fov", 170, 3)
		tween.tween_property(white, "modulate:a", 1, 3)
		await tween.finished
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file(platformer1)
