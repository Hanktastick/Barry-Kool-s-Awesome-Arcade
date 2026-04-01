extends CharacterBody3D

@onready var player = $"../Top Down Player"
@onready var animplayer = $AnimationPlayer
@onready var healthbar = $"Health Bar Pivot/SubViewport/Control/ProgressBar"
@onready var hpPivot = $"Health Bar Pivot"

@onready var meshes = [
	$head2/head,
	$Body/sphere,
	$Glasses/plane,
	$Glasses/plane2,
	$Glasses/lens,
	$BackRightLeg/cylinder, 
	$BackRightLeg/cylinder2, 
	$BackRightLeg/sphere2,
	$MiddleRightLeg/sphere3, 
	$MiddleRightLeg/cylinder3, 
	$MiddleRightLeg/cylinder4, 
	$FrontRightLeg/sphere4, 
	$FrontRightLeg/cylinder5, 
	$FrontRightLeg/cylinder6, 
	$BackLeftLeg/sphere5, 
	$BackLeftLeg/cylinder7, 
	$BackLeftLeg/cylinder8, 
	$MiddleLeftLeg/sphere6, 
	$MiddleLeftLeg/cylinder9,
	 $MiddleLeftLeg/cylinder10,
	 $FrontLeftLeg/sphere7, 
	$FrontLeftLeg/cylinder11, 
	$FrontLeftLeg/cylinder12
]

var speed = 30
var maxHP = 100.0
var hp = maxHP
var can_move = true
var can_get_hit = true
var can_hurt = true

func _ready() -> void:
	healthbar.max_value = 100.0
	healthbar.value = healthbar.max_value
	animplayer.play("walk")
	for mesh in meshes:
		var mat = mesh.get_active_material(0)
		if mat:
			mesh.set_surface_override_material(0, mat.duplicate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(player.global_position)
	rotation.x = 0
	rotation.z = 0
	rotation.y += PI
	
	hpPivot.global_rotation = Vector3.ZERO
	
	
	healthbar.value += (((hp / maxHP) * 100) - healthbar.value) / 10
	
	velocity.x = sin(rotation.y)
	velocity.z = cos(rotation.y)
	
	if can_move:
		move_and_slide()

func hit():
	if can_get_hit:
		hp -= RhythmTracker.bullet_damage
		if hp <= 0:
			die()
			pass
		var light = create_tween()
		
		var repeats = 0
		for mesh in meshes:
			
			var mat = mesh.get_active_material(0)
			
			if repeats == 0:
				light.tween_property(mat,"emission_energy_multiplier",0.25 , 0.1)
			else:
				light.parallel().tween_property(mat,"emission_energy_multiplier", 0.25, 0.1)
			repeats += 1
			
		await light.finished
		
		var dark = create_tween()
		
		repeats = 0
		for mesh in meshes:
			
			var mat = mesh.get_active_material(0)
			
			if repeats == 0:
				dark.tween_property(mat,"emission_energy_multiplier", 0.0 , 0.1)
			else:
				dark.parallel().tween_property(mat,"emission_energy_multiplier", 0.0 , 0.1)
			
			repeats += 1

func die():
	can_move = false
	can_get_hit = false
	can_hurt = false
	get_parent_node_3d().XP += randf_range(10.0,20.0)
	
	var fadeout = create_tween()
	
	var repeats = 0
	for mesh in meshes:
		
		var mat = mesh.get_active_material(0)
		
		if repeats == 0:
			fadeout.tween_property(mat,"albedo_color:a", 0.0 , 0.5)
		else:
			fadeout.parallel().tween_property(mat,"albedo_color:a", 0.0 , 0.5)
		
		repeats += 1
	
	await fadeout.finished
	
	
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()


func _on_hurt_box_body_entered(body: Node3D) -> void:
	if can_hurt:
		if body.is_in_group("Player"):
			body.hurt()
			die()
