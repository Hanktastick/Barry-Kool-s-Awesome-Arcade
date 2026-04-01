extends CharacterBody2D

@onready var white = $CanvasLayer2/ColorRect2
@onready var sprite = $AnimatedSprite2D

@export var ACCELERATION = 1750.0
@export var JUMP_VELOCITY = 275.0
@export var FRICTION = 0.8
@export var GRAVITY = 750
var max_speed = ACCELERATION * 0.663


var x_input = 0.0
var can_jump = false
var coyote_ticks = 0
var can_move = true
var used_double_jump = true
var canAnim = true

var current_checkpoint

func _ready():
	current_checkpoint = position
	white.visible = true
	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(white, "modulate:a", 0, 0.5)
	await tween.finished
	
func _physics_process(delta):
	
	if not canAnim:
		sprite.play("idle")
	
	if Input.is_action_just_pressed("Escape"):
		var pauseMenu = preload("res://Scenes/UI/pause_menu.tscn").instantiate()
		add_sibling(pauseMenu)
		pauseMenu.mouseBehavior = Input.MOUSE_MODE_VISIBLE
		
	if can_move:
		if not is_on_floor():
			velocity.y += GRAVITY * delta
			coyote_ticks += 1
		else:
			coyote_ticks = 0
			
	
	if coyote_ticks > 8:
		can_jump = false
	else:
		can_jump = true
		used_double_jump = false
	
	
	if (Input.is_action_just_pressed("Up Arrow") or Input.is_action_just_pressed("W") or Input.is_action_just_pressed("Space")):
		if not is_on_floor():
			if not used_double_jump:
				velocity.y = -JUMP_VELOCITY / 1.25 # Jump
				sprite.animation = "jump"
				sprite.speed_scale = 1.0
				sprite.play()
				used_double_jump = true
			
		elif can_jump:
			
			velocity.y = -JUMP_VELOCITY # Jump
				
			sprite.animation = "jump"
			sprite.speed_scale = 1.0
			sprite.play()

	if velocity.y > 0:
		sprite.animation = "fall"
		sprite.speed_scale = 1.0
		sprite.play()
		
	elif abs(velocity.y) < 0.1:
		if abs(velocity.x) < 10: 
			sprite.animation = "idle"
			sprite.speed_scale = 1.0
			sprite.play()
		else:
			sprite.animation = "walk"
			sprite.speed_scale = (abs(velocity.x) / max_speed) * 10
			sprite.play()
		
	if Input.is_action_pressed("D") or Input.is_action_pressed("Right Arrow"):
		x_input = 1
	elif Input.is_action_pressed("A") or Input.is_action_pressed("Left Arrow"):
		x_input = -1
	else:
		x_input = 0
		
	if velocity.x < -0.1:
		sprite.flip_h = true
	elif velocity.x > 0.1:
		sprite.flip_h = false
	
		
	velocity.x += x_input * ACCELERATION * delta
	velocity.x *= FRICTION
	
	if can_move:
		move_and_slide()
		

func die():
	can_move = false
	var tween = create_tween()
	tween.tween_property(white, "modulate:a", 1, 0.1)
	await tween.finished
	
	velocity = Vector2(0,0)
	position = current_checkpoint
	
	await get_tree().create_timer(0.5).timeout
	
	tween = create_tween()
	tween.tween_property(white, "modulate:a", 0, 0.1)
	await tween.finished
	can_move = true
	
