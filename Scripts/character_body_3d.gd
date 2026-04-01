extends CharacterBody3D

#Cam usually at 0,1.4,0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var white = $CanvasLayer2/ColorRect2
@onready var ray = $RayCast3D

var SPEED = 3
var JUMP_VELOCITY = 10
var FRICTION = 0.75
var GRAVITY = -20
var speed_cap = 10


var input_mult = 1
var can_jump = false
var coyote_ticks = 0
var can_move = true
var used_double_jump = true
var SENSITIVITY = 0.0075
var can_rotate_head = true
var crouching = false
var can_uncrouch = true
var crouch_scale = 1

var current_checkpoint: Vector3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	white.visible = true
	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(white, "modulate:a", 0, 0.5)
	await tween.finished
	
	current_checkpoint = global_position

func _unhandled_input(event):
	if event is InputEventMouseMotion and can_rotate_head:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
func _physics_process(delta):
	if can_move:
		if not is_on_floor():
			input_mult = 0.7
			velocity.y += GRAVITY * delta
			coyote_ticks += 1
		else:
			coyote_ticks = 0
			input_mult = 1
			
	if Input.is_action_just_pressed("Escape"):
		var pauseMenu = preload("res://Scenes/UI/pause_menu.tscn").instantiate()
		add_sibling(pauseMenu)
		pauseMenu.mouseBehavior = Input.MOUSE_MODE_CAPTURED

		
	if coyote_ticks > 8:
		can_jump = false
	else:
		can_jump = true
		used_double_jump = false
	

	if Input.is_action_just_pressed("Space"):
		if not is_on_floor():
			if not used_double_jump:
				used_double_jump = true
				velocity.y = JUMP_VELOCITY # Jump
			
		elif can_jump:
			
			velocity.y = JUMP_VELOCITY # Jump
			
	ray.enabled = true
	if ray.is_colliding():
		can_uncrouch = false
	else: 
		can_uncrouch = true


	if Input.is_action_pressed("Control"):
		crouching = true
	elif can_uncrouch:
		crouching = false
		
	if crouching:
		scale.y = crouch_scale
		speed_cap = 6
		if crouch_scale > 0.6:
			crouch_scale -= 0.03
		else:
			crouch_scale = 0.6

	else:
		scale.y = crouch_scale
		speed_cap = 10
		if crouch_scale < 1.0:
			crouch_scale += 0.03
		else:
			crouch_scale = 1
		
	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x += direction.x * SPEED
		velocity.z += direction.z * SPEED
		
	velocity.x *= FRICTION
	velocity.z *= FRICTION
		
	if abs(velocity.x) > speed_cap:
		if velocity.x < 0:
			velocity.x = -speed_cap
		else:
			velocity.x = speed_cap
			
	if abs(velocity.z) > speed_cap:
		if velocity.z < 0:
			velocity.z = -speed_cap
		else:
			velocity.z = speed_cap
	
	if can_move:
		move_and_slide()


func die():
	print("Die")
	can_move = false
	var tween = create_tween()
	tween.tween_property(white, "modulate:a", 0.75, 0.1)
	await tween.finished
	
	velocity = Vector3(0,0,0)
	position = current_checkpoint
	
		
	await get_tree().create_timer(0.1).timeout
	
	tween = create_tween()
	tween.tween_property(white, "modulate:a", 0, 0.1)
	await tween.finished
	can_move = true
	
