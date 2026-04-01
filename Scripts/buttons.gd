extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite

var input = ""


signal tap_note

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "default"
	sprite.play()

func click():

	sprite.stop()
	sprite.animation = "click"
	sprite.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Up Arrow"):
		input = "u"
	elif Input.is_action_just_pressed("Down Arrow"):
		input = "d"
	elif Input.is_action_just_pressed("Right Arrow"):
		input = "r"
	elif Input.is_action_just_pressed("Left Arrow"):
		input = "l"
	else:
		input = ""

	if input != "":
		click()
