extends Node2D
@onready var effects: AnimatedSprite2D = $effects

var effect = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	effects.animation = "Blank"
	
	var tween = create_tween()
	position = Vector2(0,-70)
	tween.parallel().tween_property(self, "position:y" , -120, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_callback(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	effects.animation = effect
