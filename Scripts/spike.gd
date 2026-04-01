extends Node2D

func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		if get_parent().get_parent().spikeDie < 1:
			get_parent().get_parent().spikeDie += 1
			$"../../Text Engine".write("I should probably watch out for these spikes.", Color(1.0, 1.0, 1.0, 1.0), 0.04, 1)
