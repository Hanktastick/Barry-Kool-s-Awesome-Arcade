extends CanvasLayer

var tick = 0
@onready var pausedText = $Background/Paused/Paused
@onready var optionButton = $Background/Buttons/Options
@onready var resumeButton = $Background/Buttons/Resume
@onready var quitButton =$"Background/Buttons/Quit Button"

@onready var volSlide = $"Background/Options Menu/Sliders/VolSlider"
@onready var volText = $"Background/Options Menu/Sliders/Volume"

@onready var options = $"Background/Options Menu"

var volBus = preload("res://Sounds/default_bus_layout.tres")
var mouseBehavior

var optionScale = 8.0
var resumeScale = 8.0
var sureScale = 8.0
var quitScale = 8.0

var scaleEasing = 5
var rotSpeed = 3
var rotAmt = 0.15



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio_settings = ConfigHandler.load_audio_settings()
	volSlide.value = audio_settings.master_volume
	process_mode = PROCESS_MODE_ALWAYS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pausedText.skew = sin(tick * 3) *  0.15
	tick += delta
	
	if optionButton.is_hovered():
		optionScale = 9
	else:
		optionScale = 8
	
	if resumeButton.is_hovered():
		resumeScale = 9
	else:
		resumeScale = 8
		

	if quitButton.is_hovered():
		quitScale = 9
	else:
		quitScale = 8


	optionButton.scale += Vector2((optionScale - optionButton.scale.x ) / scaleEasing, (optionScale - optionButton.scale.y ) / scaleEasing)
	resumeButton.scale += Vector2((resumeScale - resumeButton.scale.x) / scaleEasing, (resumeScale - resumeButton.scale.y ) / scaleEasing)
	quitButton.scale += Vector2((quitScale - quitButton.scale.x ) / scaleEasing, (quitScale - quitButton.scale.y ) / scaleEasing)

	optionButton.rotation = sin(tick * rotSpeed) * rotAmt
	resumeButton.rotation = sin(tick * rotSpeed + 352389) * rotAmt
	quitButton.rotation = sin(tick * rotSpeed + 1245) * rotAmt

	volText.text = "Volume: " + str(roundi(volSlide.value * 100)) + "%"
	
	AudioServer.set_bus_volume_db(0,linear_to_db(volSlide.value))

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	Input.set_mouse_mode(mouseBehavior)
	get_tree().paused = false
	
	queue_free()


func _on_back_pressed() -> void:
	options.visible = false
	ConfigHandler.save_audio_setting("master_volume", volSlide.value)


func _on_options_pressed() -> void:
	options.visible = true
