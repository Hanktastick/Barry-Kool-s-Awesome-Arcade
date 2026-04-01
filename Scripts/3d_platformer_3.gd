extends Node3D

@onready var enemies = $Enemies.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"3d_player/Head/Camera3D".current = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
	


func _on_dead_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.die()
	if body.is_in_group("Enemy"):
		body.squash()
	
func win():
	$"3d_player".die()
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/Top-Down/top_down.tscn")
	
