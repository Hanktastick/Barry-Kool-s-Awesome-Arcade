extends CharacterBody3D

@onready var player = $"../Top Down Player"
@onready var gun_point = $"../Top Down Player/Gun Point"
@onready var sprite_3d: AnimatedSprite3D = $Sprite3D
var bullet_speed = 25
var start_off: float =0
var can_move = true

func setup(_start_off: float):
	start_off = _start_off

	if RhythmTracker.lvl == 1:
		bullet_speed = 25
	elif RhythmTracker.lvl == 2:
		bullet_speed =20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation.y = player.rotation.y + PI
	rotation.y += deg_to_rad(start_off)
	global_position = gun_point.global_position
	var mat = $MeshInstance3D.get_active_material(0)
	if mat:
		$MeshInstance3D.set_surface_override_material(0, mat.duplicate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = sin(rotation.y) * bullet_speed
	velocity.z = cos(rotation.y) * bullet_speed
	velocity.y = 0
	if can_move:
		move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:

	if body.is_in_group("Enemy"):
		body.hit()
		sprite_3d.play()
		can_move = false
		
		
		var fade_out = create_tween()
		var light_out = create_tween()
		var boom_out = create_tween()
		var mat : MeshInstance3D = $MeshInstance3D
		fade_out.tween_property(mat.get_active_material(0), "albedo_color:a", 0.0, 0.1)
		light_out.tween_property($OmniLight3D, "light_energy", 0.0, 0.3)
		boom_out.tween_property($Sprite3D/OmniLight3D, "light_energy", 0.0, 1)
		await sprite_3d.animation_finished
		queue_free()
