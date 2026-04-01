extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var jump_power = -200.0
var gravity = 750.0
var jumping = false


func _physics_process(delta):

	if is_on_floor() and !jumping:
		jump()
	if is_on_floor():
		velocity.x *= 0.8
	
	velocity.y += gravity * delta

	if $"../../2D Platformer Player".position.x > position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	move_and_slide()


func jump():
	jumping = true

	sprite.play("charge_jump")
	await sprite.animation_finished
	
	$AudioStreamPlayer2D.pitch_scale = randf_range(2.25,2.75)
	$AudioStreamPlayer2D.play()
	velocity.y = jump_power
	velocity.x = -((int(sprite.flip_h) * 2) - 1) * 100

	sprite.play("release_jump")
	await sprite.animation_finished

	while !is_on_floor():
		sprite.play("air")
		await get_tree().process_frame

	sprite.play("land")
	await sprite.animation_finished

	jumping = false



func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		if get_parent().get_parent().sproingDie < 1:
			$"../../Text Engine".write("Reminds me of another basic enemy from a platformer...", Color(1.0, 1.0, 1.0, 1.0), 0.04, 1)
			get_parent().get_parent().sproingDie += 1
		body.die()



func _on_squash_box_body_entered(body):
		if body.is_in_group("Player"):
			body.velocity.y -= body.JUMP_VELOCITY
			sprite.play("charge_jump")
			var fade_out = create_tween()
			fade_out.tween_property($".", "modulate:a", 0, 0.5)
			await fade_out.finished
			queue_free()
