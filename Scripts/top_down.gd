extends Node3D


var buggyref = preload("res://Scenes/Top-Down/buggy.tscn")
@onready var player = $"Top Down Player"
@onready var xpBar = $UI/ProgressBar



var XP
var XP_max


var spawn_range = 60.0
var near_range = 20.0

var buggy :Node3D = buggyref.instantiate()
func _ready() -> void:
	XP = 0
	if RhythmTracker.lvl == 1:
		XP_max = 500
	elif RhythmTracker.lvl == 2:
		XP_max = 750
	elif RhythmTracker.lvl == 3:
		XP_max = 750
	xpBar.max_value = XP_max
	xpBar.value = XP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if RhythmTracker.lvl == 1:
		if randi_range(0,200) == 0:
			spawn()
	elif RhythmTracker.lvl == 2:
		if randi_range(0,150) == 0:
			spawn()
	elif RhythmTracker.lvl == 3:
			if randi_range(0,100) == 0:
				spawn()
	xpBar.value += (XP - xpBar.value) / 30
	
	if XP >= XP_max:
		win()

func spawn():
	
	buggy = buggyref.instantiate()
	
	buggy.position = Vector3(
	
	player.position.x + (((randi_range(0,1) * 2) -1) * randf_range(near_range,spawn_range)),
	0,
	player.position.z + (((randi_range(0,1) * 2) -1) * randf_range(near_range,spawn_range))
	
	)
	
	add_child(buggy)

func win():
	if RhythmTracker.lvl == 3:
		var rhythm_scene = load("res://Scenes/Rhythm/main.tscn")
		get_tree().change_scene_to_packed(rhythm_scene)
	else:
		RhythmTracker.lvl += 1
		get_tree().reload_current_scene()
		
