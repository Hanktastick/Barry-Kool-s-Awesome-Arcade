extends CanvasLayer

var speed = 40

var opened :bool = false

func _ready():
	$Label.size.x = 0
	
func _process(delta):
	
	
	if not opened:
		$Label.size.x += (1000 - $Label.size.x) / 30
		$Label.position.x =  get_viewport().size.x/2 - $Label.size.x /2
		$Label.size.x = $Label.size.x
		
		if $Label.size.x > 999:
			$Label.size.x = 1000
			opened = true
	else:
		if $Label.position.y > -2600:
			
			$Label.position.y -= speed * delta
		else:
			quit()
		
		if Input.is_action_pressed("Space"):
			speed += 4.0
		else:
			speed += (40.0 - speed ) / 20.0

func quit():
	await get_tree().create_timer(2).timeout
	get_tree().quit()
