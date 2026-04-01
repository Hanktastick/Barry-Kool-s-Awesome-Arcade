extends CharacterBody3D

@onready var camera = $"../Camera3D"
@onready var timer = $"Shoot Timer"

@onready var heart1 : AnimatedSprite2D = $"../UI/Control/Heart1"
@onready var heart2 : AnimatedSprite2D = $"../UI/Control/Heart2"
@onready var heart3 : AnimatedSprite2D = $"../UI/Control/Heart3"



@onready var red = $CanvasLayer2/ColorRect2
var speed = 45
var friction = 0.9
var cam_height = 15
var cooldown = 0.25
var can_shoot = true
var bullet_ref = preload("res://Scenes/Top-Down/bullet.tscn")
var shooting = false
var bullet = bullet_ref.instantiate()
var light_energy = 0.0
var startHP = RhythmTracker.HP
func _ready():
	
	red.visible = true
	
	var tween = create_tween()
	tween.tween_property(red, "modulate:a", 0, 0.3)
	if RhythmTracker.lvl == 1:
		cooldown = 0.25
	elif RhythmTracker.lvl == 2:
		cooldown = 0.6
	elif RhythmTracker.lvl == 3:
		cooldown = 0.75
	
	timer.wait_time = cooldown
		
	
func _physics_process(delta):
	
	
	if Input.is_action_just_pressed("Escape"):
		var pauseMenu = preload("res://Scenes/UI/pause_menu.tscn").instantiate()
		add_sibling(pauseMenu)
		pauseMenu.mouseBehavior = Input.MOUSE_MODE_VISIBLE
		
	if Input.is_action_pressed("Left Click") and timer.is_stopped():
		shoot()
		
	var input_dir = Vector2(Input.get_axis("A","D"),Input.get_axis("W","S"))
	
	velocity.x += input_dir.x * delta * speed
	velocity.z += input_dir.y *delta * speed
	
	velocity *= friction
	
	camera.position += (global_position - camera.global_position) / 40
	camera.position.y = position.y + cam_height
	
	
	var mousePos = get_viewport().get_mouse_position()
	
	var rayStart = camera.project_ray_origin(mousePos)
	var direction = camera.project_ray_normal(mousePos)
	
	var t = -rayStart.y / direction.y
	var world_mouse_pos = rayStart + direction * t
	
	look_at(world_mouse_pos)
	rotation.x = 0
	rotation.z = 0
	move_and_slide()
	
	if RhythmTracker.HP == 1:
		heart3.play("broken")
		heart2.play("broken")
		heart1.play("full")
	elif RhythmTracker.HP == 2:
		heart3.play("broken")
		heart2.play("full")
		heart1.play("full")
	elif RhythmTracker.HP == 3:
		heart3.play("full")
		heart2.play("full")
		heart1.play("full")
		
func shoot():
	

	if RhythmTracker.lvl == 1:
		bullet = bullet_ref.instantiate()
		bullet.setup(0)
		velocity.x += sin(rotation.y) * 2
		velocity.z += cos(rotation.y) * 2
		
		add_sibling(bullet)
	elif RhythmTracker.lvl == 2:
		for i in range(5):
			bullet = bullet_ref.instantiate()
			velocity.x += sin(rotation.y) * 2
			velocity.z += cos(rotation.y) * 2
			bullet.setup((i * 10) -25)
			
			add_sibling(bullet)
	elif RhythmTracker.lvl == 3:
		
		timer.start()
		for i in range(3):
			bullet = bullet_ref.instantiate()
			
			add_sibling(bullet)
			await get_tree().create_timer(0.05).timeout
			velocity.x += sin(rotation.y) * 3
			velocity.z += cos(rotation.y) * 3
		
	timer.start()
	
func hurt():
	RhythmTracker.HP -= 1
	if RhythmTracker.HP <= 0:
		die()
		
	var tween = create_tween()
	tween.tween_property(red, "modulate:a", 0.75, 0.1)
	await tween.finished
	
	velocity = Vector3(0,0,0)
	
		
	await get_tree().create_timer(0.3).timeout
	
	tween = create_tween()
	tween.tween_property(red, "modulate:a", 0, 0.1)
	await tween.finished
	
func die():
	RhythmTracker.HP = startHP
	var tween = create_tween()
	tween.tween_property(red, "modulate:a", 1, 0.25)
	await tween.finished
	
	velocity = Vector3(0,0,0)
	
	get_tree().paused = true
	
	await get_tree().create_timer(2).timeout
	
	get_tree().paused = false
	
	get_tree().reload_current_scene()
	
