extends Node2D
@onready var note_sprite: AnimatedSprite2D = $note_sprite
@onready var y_pos = position.y

var note_type = null
var can_tap = false
var dist_to_tap = null
var TIMESCALE = 1.0
signal note_missed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_sprite.animation = "normal"
	await note_type != null
	if note_type == "d":
		set_position(Vector2(0,1000))
		rotation_degrees = 180
	elif note_type == "u":
		set_position(Vector2(0,-1000))
		rotation_degrees = 0
	elif note_type == "l":
		set_position(Vector2(-1000,0))
		rotation_degrees = 270
	elif note_type == "r":
		set_position(Vector2(1000,0))
		rotation_degrees = 90
	else:
			queue_free()

func fade_out():
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.parallel().tween_property(self, "modulate:v", 0, 0.2)
	tween.tween_callback(queue_free)
	

func note_hit():
		note_sprite.animation = "hit"
		note_sprite.play()
		print("hit note")
		await note_sprite.animation_finished
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if note_type != null:
		if note_sprite.animation != "hit":
			if note_type == "d":
				position.y -= 500 * delta * TIMESCALE
			elif note_type == "u":
				position.y += 500 * delta * TIMESCALE
			elif note_type == "l":
				position.x += 500 * delta * TIMESCALE
			elif note_type == "r":
				position.x -= 500 * delta * TIMESCALE
	else:
		pass


func _on_body_area_exited(area: Area2D) -> void:

	if area.name == "Hitbox" and note_sprite.animation != "hit":
		fade_out()
		emit_signal("note_missed")
