extends Node2D
@onready var timer: Timer = $Timer
@onready var note_scene = preload("res://Scenes/Rhythm/notes.tscn")
@onready var song_start_delay: Timer = $song_start_delay
@onready var score_scene = preload("res://Scenes/Rhythm/scores.tscn")
@onready var race_me_scene = preload("res://Scenes/Rhythm/race_me_song.tscn")
@onready var candy_scene = preload("res://Scenes/Rhythm/candy_song.tscn")
@onready var barry_scene = preload("res://Scenes/Rhythm/barry_song.tscn")
@onready var barry: AudioStreamPlayer = $barry
@onready var candy: AudioStreamPlayer = $candy
@onready var race_me: AudioStreamPlayer = $race_me




var BPM = [130.0, 140.0, 218.0]
var note_amount = 0
var notes = []
var input = null
var note_dist = null
var accuracy = null
var mode = "playing"
var is_game_running = true
var overload_count = 0
var song_number = RhythmTracker.song

var race_me_note_list = [
	 "n",
	 "l", "r", "l", "r", "l", "r", "l", "r",
	 "d", "u", "d", "u", "d", "u", "d", "u",
	 "l", "u", "r", "u", "l", "u", "r", "u",
	 "l", "l", "r", "r", "d", "d", "u", "u",
	 "l", "r", "l", "r", "l", "r", "l", "r",
	 "d", "l", "d", "l", "d", "l", "d", "l",
	 "u", "r", "u", "r", "u", "r", "u", "r",
	 "d", "d", "l", "l", "r", "r", "d", "d",
	 "u", "u", "l", "r", "l", "r", "l", "r",
	 "d", "d", "l", "l", "u", "u", "r", "r",
	 "u", "u", "u", "u", "l", "l", "r", "r",
	 "d", "d", "d", "l", "l", "r", "r", "r",
	 "u", "u", "d", "d", "l", "l", "r", "r",
	 "u", "l", "d", "r", "u", "l", "d", "r",
	 "u", "d", "l", "r", "d", "u", "l", "r",
	 "d", "d", "u", "u", "u", "d", "d", "d",
	 "l", "r", "l", "r", "r", "l", "d", "d",
	 "u", "u", "u", "d", "d", "l", "l", "r",
	 "r", "r", "r", "l", "u", "u", "u", "u",
	 "d", "d", "u", "u", "u", "l", "r", "u",
	 "u", "u", "u", "u", "d", "d", "u", "u",
	 "u", "u", "u", "l", "l", "l", "l", "r",
	 "r", "r", "r", "u", "n", "u", "n", "r",
	 "n", "l", "n", "d", "n", "u", "n", "u"
	]

var candy_note_list = [
	"n",
	"l", "n", "d", "d", "r", "n", "d", "d",
	"u", "n", "d", "d", "u", "n", "d", "d", 
	"l", "n", "r", "r", "d", "n", "l", "r", 
	"d", "n", "d", "u", "d", "u", "d", "l", 
	"r", "l", "r", "l", "r", "r", "r", "l", 
	"l", "d", "d", "l", "l", "r", "r", "r", 
	"d", "d", "l", "l", "u", "u", "l", "u", 
	"l", "l", "r", "l", "r", "l", "r", 
	"l", "r", "r", "l", "l", "d", "d", "l", 
	"l", "r", "r", "d", "d", "l", "l", "r", 
	"d", "l", "l", "r", "r", "l", "l", "r", 
	"r", "u", "u", "d", "d", "l", "l", "l", 
	"l", "d", "r", "u", "l", "d", "r", "u", 
	"l", "d", "r", "u", "l", "d", "r", "u", 
	"l", "d", "u", "l", "d", "r", "u", "l", 
	"d", "r", "d", "l", "u", "r", "u", "l", 
	"d", "l", "r", "l", "r", "l", "l", "r", 
	"r", "d", "l", "r", "r", "d", "d", "u", 
	"l", "r", "u", "r", "l", "u", "l", "r", 
	"d", "l", "u", "r", "l", "u", "r", "d", 
	"d", "r", "l", "r", "d", "d", "d", "d", 
	"r", "l", "r", "l", "r", "l", "u"
]

var barry_note_list = [
	"n",
	"u", "u", "u", "u", "u", "l", 
	"l", "r", "r", "u", "u", "d", 
	"d", "l", "l", "r", "r", "u", 
	"u", "d", "u", "d", "u", "l", 
	"r", "u", "d", "u", "d", "l", 
	"r", "l", "r", "d", "d", "d", 
	"u", "u", "u", "l", "l", "r", 
	"r", "d", "d", "u", "d", "u", "d", "l", "u", 
	"r", "d", "l", "u", "r", "d", "l", "u", "r", 
	"d", "l", "u", "r", "d", "l", "u", "r", "d", 
	"l", "u", "r", "u", "l", "d", "r", "u", "l", 
	"d", "r", "u", "r", "d", "l", "u", "r", "u", 
	"l", "d", "r", "u", "r", "d", "l", "u", "r", 
	"u", "l", "d", "r", "u", "r", "d", "l", "u", 
	"d", "d", "d", "l", "l", "l", "r", "r", "d", 
	"d", "u", "u", "d", "d", "l", "l", "r", "r", 
	"d", "l", "r", "u", "d", "u", "d", "u", "d", 
	"d", "d", "l", "l", "r", "r", "r", "l", "l", 
	"d", "d", "u", "u"]

var note_list_1 = [

	]
var charts = [candy_note_list.duplicate(), race_me_note_list.duplicate(), barry_note_list.duplicate()]
var chart = charts[song_number]
var misses = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$CanvasLayer/FadeRect.modulate.a = 1.0
	timer.wait_time = round(60.0/BPM[song_number] * 1000000000)/1000000000.0
	song_start_delay.wait_time = 3.0 + timer.wait_time/2.0
	$song_start_delay.start()
	print(timer.wait_time)
	$CanvasLayer/ColorRect.material.set_shader_parameter("tint_strength", 0.0)
	$CanvasLayer/ColorRect.material.set_shader_parameter("strength", 0.0)
	var note = $CanvasLayer/CenterContainer/TextureRect.get_node_or_null("Notes")
	var song
	print("2")
	
	
	if song_number == 0:
		song = candy_scene.instantiate()
		$CanvasLayer/CenterContainer/TextureRect/Label.text = "Now Playing:\nCandy ~ MXSounds"
	elif song_number == 1:
		song = race_me_scene.instantiate()
		$CanvasLayer/CenterContainer/TextureRect/Label.text = "Now Playing:\nRace Me ~ MXSounds"
		$CanvasLayer/CenterContainer/TextureRect/Label.modulate = Color(0.0, 0.612, 0.795, 1.0)
	else:
		song = barry_scene.instantiate()
		$CanvasLayer/CenterContainer/TextureRect/Label.text = "Now Playing:\nBarry Kool's Theme ~ SNvChipehs"
		$CanvasLayer/CenterContainer/TextureRect/Label.modulate = Color(0.988, 1.0, 0.059, 1.0)
	print("3")
	$CanvasLayer/CenterContainer/TextureRect.add_child(song)
	
	if note:
		note.note_missed.connect()
	print("4")
	var label_in = create_tween()
	label_in.tween_property($CanvasLayer/CenterContainer/TextureRect/Label, "modulate",Color(modulate.r, modulate.g, modulate.b, 1.0),2)
	label_in.set_trans(Tween.TRANS_SINE)
	label_in.set_ease(Tween.EASE_IN_OUT)
	label_in.play()
	print("5")
	var mat = $CanvasLayer/ColorRect.material
	mat.set_shader_parameter("vignette_radius", 0.0000001)
	await get_tree().create_timer(0.3).timeout
	$CanvasLayer/FadeRect.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/vignette_radius", 1.2, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(5).timeout
	var label_out = create_tween()
	label_out.tween_property($CanvasLayer/CenterContainer/TextureRect/Label, "modulate",Color(modulate.r, modulate.g, modulate.b, 0.0),1)
	label_out.set_trans(Tween.TRANS_SINE)
	label_out.set_ease(Tween.EASE_IN_OUT)
	label_out.play()
	print("6")


func tap():
	var is_note = $CanvasLayer/CenterContainer/TextureRect.get_node_or_null("Notes")
	if is_note:
		$CanvasLayer/CenterContainer/TextureRect/Notes.note_hit()
	else:
		pass

func spawn_note(type):
	var note = note_scene.instantiate()
	note.note_type = type
	$CanvasLayer/CenterContainer/TextureRect.add_child(note)
	notes.append(note)
	note.note_missed.connect(note_miss)

var tint_effect

func effects_note_hit(blur_strength):
	var mat = $CanvasLayer/ColorRect.material
	var score = score_scene.instantiate()
	$CanvasLayer/CenterContainer/TextureRect.add_child(score)
	if tint_effect:
		tint_effect.kill()
	
	mat.set_shader_parameter("strength", blur_strength)
	if accuracy == "perfect":
		mat.set_shader_parameter("tint_color", Color(0.833, 0.0, 1.0, 0.498))
		score.effect = "Kool"
	elif accuracy == "good":
		mat.set_shader_parameter("tint_color", Color(0.0, 0.77, 0.321, 0.424))
		score.effect = "Good"
	else:
		mat.set_shader_parameter("tint_color", Color(0.86, 0.43, 0.0, 0.384))
		score.effect = "Meh"
	mat.set_shader_parameter("tint_strength", 0.3)
	var tween = create_tween()
	tint_effect = create_tween()
	tint_effect.parallel().tween_property(mat, "shader_parameter/tint_strength", 0.0, 0.5)
	tint_effect.parallel().tween_property(mat, "shader_parameter/tint_strength", 0.0, 0.5)
	tween.parallel().tween_property(mat, "shader_parameter/strength", 0.0, 0.25)
	


func check_note(input_type, type):
	var closest = null
	var best_dist = 70
	if mode != "charting":
		if is_game_running == true:
			if Input.is_action_just_pressed(input_type):
				for note in notes:
					if !is_instance_valid(note):
						continue
					note_dist = note.position.length()
					
					if note_dist == null:
						note_dist = 1
						
					if note_dist < best_dist:
						best_dist = note_dist
						closest = note
					
				if closest and closest.note_type == type:
					overload_count = 0
					closest.note_hit()
					notes.erase(closest)
					if best_dist < 8:
						accuracy = "perfect"
						effects_note_hit(0.1)
					elif best_dist < 30:
						accuracy = "good"
						effects_note_hit(0.05)
					else:
						accuracy = "meh"
						effects_note_hit(0.02)
				else:
					overload_count += 1
					if overload_count == 4:
						var score = score_scene.instantiate()
						$CanvasLayer/CenterContainer/TextureRect.add_child(score)
						score.effect = "Too_many"
						you_lose()
	else:
		if Input.is_action_just_pressed(input_type):
			if note_amount < 147:
				note_list_1.append(type)
				note_amount += 1
				print(note_amount)
			else:
				print(note_list_1)



func note_miss():
	var score = score_scene.instantiate()
	$CanvasLayer/CenterContainer/TextureRect.add_child(score)
	score.effect = "Miss"
	print("miss")
	misses += 1
	if misses == 3:
		you_lose()


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		var pauseMenu = preload("res://Scenes/UI/pause_menu.tscn").instantiate()
		add_sibling(pauseMenu)
		pauseMenu.mouseBehavior = Input.MOUSE_MODE_VISIBLE
		
	check_note("Up Arrow","u")
	check_note("Down Arrow","d")
	check_note("Left Arrow","l")
	check_note("Right Arrow","r")
	check_note("Space", "n")
	$CanvasLayer/ColorRect.material.set_shader_parameter("screen_size", get_viewport().size)


func _on_timer_timeout() -> void:
	if !chart.is_empty() and mode != "charting":
		spawn_note(chart[0])
		chart.remove_at(0)

func you_lose():
	
	if mode != "charting":
		
		misses = 0
		overload_count = 0
		$song_start_delay.stop()
		is_game_running = false
		if song_number == 0:
			$candy.stop()
		elif song_number == 1:
			$race_me.stop()
		else:
			$barry.stop()
		timer.stop()
		charts = [candy_note_list.duplicate(), race_me_note_list.duplicate(), barry_note_list.duplicate()]
		chart = charts[song_number]
		var mat = $CanvasLayer/ColorRect.material
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/vignette_radius", 0.0001, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		for note in notes:
			if is_instance_valid(note):
				note.TIMESCALE = 0
				note.queue_free()
		$CanvasLayer/FadeRect.modulate.a = 1.0
		
		await get_tree().create_timer(0.3).timeout
		var thing_mat = $CanvasLayer/ColorRect.material
		thing_mat.set_shader_parameter("vignette_radius", 0.0000001)
		song_start_delay.start()
		await get_tree().create_timer(0.2).timeout
		$CanvasLayer/FadeRect.modulate.a = 0
		var tween2 = create_tween()
		tween2.tween_property(mat, "shader_parameter/vignette_radius", 1.2, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween2.finished
		is_game_running = true
		timer.start()
		misses = 0



func _on_song_start_delay_timeout() -> void:
	if song_number == 0:
		$candy.play()
	elif song_number == 1:
		$race_me.play()
	else:
		$barry.play()


func _on_race_me_finished() -> void:
	await get_tree().create_timer(5).timeout
	
	var mat = $CanvasLayer/ColorRect.material
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/vignette_radius", 0.0001, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	RhythmTracker.song = 2
	get_tree().change_scene_to_file("res://Scenes/fake_barry.tscn")


func _on_candy_finished() -> void:
	await get_tree().create_timer(5).timeout
	
	var mat = $CanvasLayer/ColorRect.material
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/vignette_radius", 0.0001, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	RhythmTracker.song = 1
	get_tree().reload_current_scene()
	


func _on_barry_finished() -> void:
	await get_tree().create_timer(3).timeout
	
	var mat = $CanvasLayer/ColorRect.material
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/vignette_radius", 0.0001, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
