extends Camera2D

export var speed = 10.0

func _ready():
	pass

func _process(delta):
	
	# Smooth movement
	var input_x = (int(Input.is_action_pressed("ui_right")) 
		- int(Input.is_action_pressed("ui_left")))
		
	var input_y = (int(Input.is_action_pressed("ui_down")) 
		- int(Input.is_action_pressed("ui_up")))
	
	position.x += input_x * speed
	position.y += input_y * speed
	
	pass
