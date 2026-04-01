extends Node2D

@onready var text: CanvasLayer = $"Text Engine"
@onready var bigB: AnimatedSprite2D = $"The Big B Himself"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var fadein = create_tween()
	fadein.tween_property($ColorRect,"modulate:a",0.0,1)
	await fadein.finished
	var move = create_tween()
	move.tween_property(bigB,"position",Vector2(375,-350),1)
	move.set_ease(Tween.EASE_OUT)
	move.set_trans(Tween.TRANS_SINE)
	await move.finished
	text.write("Heya, kiddo! This is the end. My own song, Y'Know.",  Color(0.988, 1.0, 0.506, 1.0), 0.13,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Good. I'm finally at the end. Well, this has been a nightmare.",  Color(1.0, 1.0, 1.0, 1.0), 0.13,1)
	while text.writing:
		await get_tree().process_frame
	text.write("For you, maybe, kiddo. Y'Know, you're the only person I've seen in a real long time. Good luck, kiddo.",   Color(0.988, 1.0, 0.506, 1.0), 0.13,1)
	while text.writing:
		await get_tree().process_frame
	text.write("Thanks..?",  Color(1.0, 1.0, 1.0, 1.0), 0.13,1)
	while text.writing:
		await get_tree().process_frame
		
	await get_tree().create_timer(1).timeout
	var up = create_tween()
	up.tween_property(bigB,"position",Vector2(375,-350),1)
	up.set_ease(Tween.EASE_OUT)
	up.set_trans(Tween.TRANS_SINE)
	
	RhythmTracker.song = 2
	await up.finished
	var fadeout = create_tween()
	fadeout.tween_property($ColorRect, "modulate:a",1.0,1)
	get_tree().change_scene_to_file("res://Scenes/Rhythm/main.tscn")
