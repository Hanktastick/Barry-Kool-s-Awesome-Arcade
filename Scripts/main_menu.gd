extends CanvasLayer

var tick = 0

@onready var titleText = $Title/Title
@onready var startButton = $Start
@onready var optionButton = $Options
@onready var quitButton = $"Quit Button"

@onready var volSlide = $"Options Menu/Sliders/VolSlider"
@onready var volText = $"Options Menu/Sliders/Volume"

@onready var options = $"Options Menu"

var volBus = preload("res://Sounds/default_bus_layout.tres")



var optionScale = 8.0
var startScale = 2.0
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
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	titleText.rotation = sin(tick * 3) *  0.05
	titleText.skew = sin(tick) *  0.1
	
	tick += delta
	
	if optionButton.is_hovered():
		optionScale = 10
	else:
		optionScale = 8
	
	if quitButton.is_hovered():
		quitScale = 6
	else:
		quitScale = 8

	if startButton.is_hovered():
		startScale = 3
	else:
		startScale = 2
		
	optionButton.scale += Vector2((optionScale - optionButton.scale.x ) / scaleEasing, (optionScale - optionButton.scale.y ) / scaleEasing)
	startButton.scale += Vector2((startScale - startButton.scale.x ) / scaleEasing, (startScale - startButton.scale.y ) / scaleEasing)
	quitButton.scale += Vector2((quitScale - quitButton.scale.x ) / scaleEasing, (quitScale - quitButton.scale.y ) / scaleEasing)

	optionButton.rotation = sin(tick * rotSpeed) * rotAmt
	quitButton.rotation = sin(tick * rotSpeed + 1245) * rotAmt
	
	startButton.rotation = sin(tick * rotSpeed + 12453251) * rotAmt
	
	volText.text = "Volume: " + str(roundi(volSlide.value * 100)) + "%"
	
	AudioServer.set_bus_volume_db(0,linear_to_db(volSlide.value))

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	options.visible = false
	ConfigHandler.save_audio_setting("master_volume", volSlide.value)


func _on_options_pressed() -> void:
	options.visible = true




func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/3d_intro.tscn")
