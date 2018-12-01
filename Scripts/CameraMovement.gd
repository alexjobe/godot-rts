extends Camera2D

export var panspeed = 30.0
export var speed = 30.0
export var zoomspeed = 20.0

export var zoomMin = 0.5
export var zoomMax = 2.0
export var marginX = 200.0
export var marginY = 100.0

var mousepos = Vector2()
var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false

func _ready():
	pass

func _process(delta):
	
	# Smooth movement
	var input_x = (int(Input.is_action_pressed("ui_right")) 
		- int(Input.is_action_pressed("ui_left")))
		
	var input_y = (int(Input.is_action_pressed("ui_down")) 
		- int(Input.is_action_pressed("ui_up")))
	
	position.x = lerp(position.x, position.x + input_x * speed * zoom.x, speed * delta)
	position.y = lerp(position.y, position.y + input_y * speed * zoom.y, speed * delta)
	
	
	# Pan camera when mouse approaches the window border
	var marginFromRight = OS.window_size.x - marginX
	var marginFromBottom = OS.window_size.y - marginY
	
	if mousepos.x < marginX:
		position.x = lerp(position.x, position.x - abs(mousepos.x - marginX) / marginX * panspeed * zoom.x, panspeed * delta)
	elif mousepos.x > marginFromRight:
		position.x = lerp(position.x, position.x + abs(mousepos.x - marginFromRight) / marginX * panspeed * zoom.x, panspeed * delta)
		
	if mousepos.y < marginY:
		position.y = lerp(position.y, position.y - abs(mousepos.y - marginY) / marginY * panspeed * zoom.x, panspeed * delta)
	elif mousepos.y > marginFromBottom:
		position.y = lerp(position.y, position.y + abs(mousepos.y - marginFromBottom) / marginY * panspeed * zoom.x, panspeed * delta)
	
	# Camera zoom
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomfactor = 1.0
	

func _input(event):
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
		else:
			zooming = false
			
	if event is InputEventMouse:
		mousepos = event.position
			
			
			
			
			 
