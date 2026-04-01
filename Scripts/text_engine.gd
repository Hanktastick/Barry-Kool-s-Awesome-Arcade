extends CanvasLayer

@onready var label: RichTextLabel = $PanelContainer/MarginContainer/RichTextLabel
var text_speed = 0.075
var writing = false

func write(text: String, color: Color, speed: float, end_time: float):
	if not writing:
		if speed:
			text_speed = speed
	
		if color:
			label.add_theme_color_override("default_color", color)
		else:
			label.add_theme_color_override("default_color", Color(1.0, 1.0, 1.0, 1.0))
		
		writing = true
		var fade_in = create_tween()
		fade_in.tween_property($PanelContainer, "modulate:a", 1.0, 0.5)
		await fade_in.finished
		
		var current_text = ""
		
		for i in text.length():
			current_text = current_text + text[i]
			label.text = current_text
			$AudioStreamPlayer.pitch_scale = randf_range(0.25,0.5)
			$AudioStreamPlayer.play()
			await get_tree().create_timer(text_speed).timeout
			
		await get_tree().create_timer(end_time).timeout
		
		var fade_out = create_tween()
		fade_out.tween_property($PanelContainer, "modulate:a", 0.0, 0.5)
		current_text = ""
		label.text = ""
		writing = false
