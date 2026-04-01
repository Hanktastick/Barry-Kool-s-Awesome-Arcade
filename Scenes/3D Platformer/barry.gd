extends Node3D

@onready var fire: MeshInstance3D = $MeshInstance3D3
@onready var curve: Curve = preload("res://Scenes/3D Platformer/fire.tres")
var tick = 0
@onready var myY = position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curve.set_point_value(2,(sin(tick)*0.6)+0.6)
	scale.y = (sin(tick ) * 0.1) + 0.9

	position.y = (myY + (scale.y * 2) ) + (sin(tick ) * 0.1)
	tick += 0.1
	
