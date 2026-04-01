extends CharacterBody3D

@onready var animplayer = $AnimationPlayer
@onready var player = $"../../3d_player"
@onready var meshes = [
	$Bottom,
	$Springs/Spring1,
	$Springs/Spring2,
	$Springs/Spring3,
	$Springs/Spring4,
	$Head2/Head
]


var jump_power = 10.0
var gravity = -20
var jumping = false

func _ready():
	for mesh in meshes:
		var mat = mesh.get_active_material(0)
		if mat:
			mesh.set_surface_override_material(0, mat.duplicate())

func _physics_process(delta):
	
	if is_on_floor() and !jumping:
		jump()
	if is_on_floor():
		velocity.x *= 0.8
		velocity.z *= 0.8
	
	velocity.y += gravity * delta

	
	move_and_slide()


func jump():
	jumping = true
	
	
	var old_dir = Vector3(0.0,rotation.y,rotation.z)
	look_at(player.global_position)
	var new_dir = Vector3(0.0,rotation.y,rotation.z)
	rotation = old_dir
	var jump_dir = player.global_position - global_position
	jump_dir.y = 0
	jump_dir = jump_dir.normalized()
	
	var point = create_tween()
	point.set_ease(Tween.EASE_IN_OUT)
	point.set_trans(Tween.TRANS_SINE)
	point.tween_property(self,"rotation",new_dir,0.5)
	
	await point.finished
	
	
	animplayer.play("Charge Jump")
	await animplayer.animation_finished

	
	
	velocity.y = jump_power
	velocity.x = jump_dir.x * jump_power / 2
	velocity.z = jump_dir.z * jump_power / 2
	
	$AudioStreamPlayer3D.play()
	
	animplayer.play("Release Jump")
	await animplayer.animation_finished

	while !is_on_floor():
		animplayer.play("In Air")
		await get_tree().process_frame

	animplayer.play("Land")
	await animplayer.animation_finished

	jumping = false
	
func squash():
	animplayer.play("Charge Jump")
	var fade_out = create_tween()
	
	
	var repeats = 0
	for mesh in meshes:
		
		var mat = mesh.get_active_material(0)
		
		if repeats == 0:
			fade_out.tween_property(mat,"albedo_color:a", 0.0 , 1.0)
		else:
			fade_out.parallel().tween_property(mat,"albedo_color:a", 0.0 , 1.0)
		
		repeats += 1
		
	await fade_out.finished
	queue_free()


func _on_squash_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player.velocity.y += player.JUMP_VELOCITY
		squash()
		
	


func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.die()
