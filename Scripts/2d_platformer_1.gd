extends Node2D

var sproingDie = 0
var spikeDie = 0

@onready var theBigB = $"The Big B Himself"
@onready var player :CharacterBody2D = $"2D Platformer Player"
@onready var playerAnim: AnimatedSprite2D = $"2D Platformer Player/AnimatedSprite2D"
@onready var textEngine = $"Text Engine"


var barryTargetOff = Vector2(500,-300)
var barryTargetPos = Vector2()

func _on_die_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		body.die()
		

func _ready():
	player.can_move = false
	playerAnim.animation = "idle"
	player.canAnim = false
	await get_tree().create_timer(3).timeout
	textEngine.write("Whoa! What in the world? \n Where am I?", Color(1.0, 1.0, 1.0, 1.0), 0.08, 1.5)
	await get_tree().create_timer(5).timeout
	$"2D Platformer Player/AudioStreamPlayer".stop()
	$AudioStreamPlayer.play()
	barryTargetOff = Vector2(125,-60)
	await get_tree().create_timer(0.5).timeout
	textEngine.write("Heya, kiddo! \n Y'know, it's not very nice to break into someones arcade, right?", Color(0.988, 1.0, 0.506, 1.0), 0.08, 1)
	await get_tree().create_timer(8.25).timeout
	textEngine.write("Who in the heck are you? An overinflated banana?", Color(1.0, 1.0, 1.0, 1.0), 0.07, 1)
	await get_tree().create_timer(6).timeout
	textEngine.write("Y'know kiddo, you CANNOT be insulting ME, the one and only... \n BARRY KOOL!!!", Color(0.988, 1.0, 0.506, 1.0), 0.08, 1.5)
	await get_tree().create_timer(8.5).timeout
	textEngine.write("Yeah, not ringing a bell.", Color(1.0, 1.0, 1.0, 1.0), 0.07, 1)
	await get_tree().create_timer(6).timeout
	textEngine.write("Wait a minute... Barry Kool? \n I used to play all of the games made after him.", Color(0.523, 0.523, 0.523, 1.0), 0.07, 1)
	await get_tree().create_timer(8).timeout
	textEngine.write("Ya sure did, kiddo. Y'know, I used to be a [[BIG SHOT]]", Color(0.988, 1.0, 0.506, 1.0), 0.08, 1.5)
	await get_tree().create_timer(9).timeout
	textEngine.write("Yeah, I don't really care. Do you mind? I'm trying to escape your stupid arcade game.", Color(1.0, 1.0, 1.0, 1.0), 0.07, 1)
	await get_tree().create_timer(10).timeout
	textEngine.write("Y'know, thats not a very nice way to talk to someone like me. See ya later, kiddo!", Color(0.988, 1.0, 0.506, 1.0), 0.08, 1.5)
	await get_tree().create_timer(9).timeout
	
	player.can_move = true
	player.canAnim = true
	barryTargetOff = Vector2(500,-300)
	$AudioStreamPlayer.stop()
	$"2D Platformer Player/AudioStreamPlayer".play()
	

func win():
	player.die()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://Scenes/2D Platformer/2d_platformer_2.tscn")


func _process(delta: float) -> void:
	theBigB.position -= (theBigB.position - barryTargetPos) / 20
	
	barryTargetPos = Vector2(player.position.x + barryTargetOff.x,player.position.y + barryTargetOff.y)
