extends Camera2D

export var panspeed = 30.0
export var speed = 30.0
export var zoomspeed = 20.0

export var zoomMin = 0.5
export var zoomMax = 2.0
export var marginX = 100.0
export var marginY = 50.0

var mousepos = Vector2()
var mouseposGlobal = Vector2()
var start = Vector2()
var startv = Vector2()
var end = Vector2()
var endv = Vector2()
var zoomfactor = 1.0
var zooming = false
var is_dragging = false
var move_to_point = Vector2()

onready var rectd = $'../UI/Base/DrawRect'

signal area_selected
signal start_move_selection

func _ready():
	connect("area_selected", get_parent(), "area_selected", [self])
	connect("start_move_selection", get_parent(), "start_move_selection", [self]) 

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
	
	# Drag selection
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		start = mouseposGlobal
		startv = mousepos
		is_dragging = true
	if is_dragging:
		end = mouseposGlobal
		endv = mousepos
		draw_area()
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startv.distance_to(mousepos) > 20:
			end = mouseposGlobal
			endv = mousepos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false
			draw_area(false)
			
	if Input.is_action_just_released("ui_right_mouse_button"):
		move_to_point = mouseposGlobal
		emit_signal("start_move_selection")
	
	# Camera zoom
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomfactor = 1.0
		
func draw_area(s = true):
	rectd.rect_size = Vector2(abs(startv.x - endv.x), abs(startv.y - endv.y))
	
	var pos = Vector2()
	pos.x = min(startv.x, endv.x)
	pos.y = min(startv.y, endv.y)
	pos.y -= OS.window_size.y
	rectd.rect_position = pos
	
	rectd.rect_size *= int(s) # true = 1 and false = 0
	

func _input(event):
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
		else:
			zooming = false
			
	if event is InputEventMouse:
		mousepos = event.position
		mouseposGlobal = get_global_mouse_position()
			
			
			
			
			 
