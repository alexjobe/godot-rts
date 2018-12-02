extends KinematicBody2D

export var selected = false setget set_selected
onready var box = $Box
onready var label = $Label
onready var bar = $Bar

signal was_selected
signal was_deselected

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		bar.visible = value
		label.visible = value
	if selected:
		emit_signal("was_selected", self)
	else:
		emit_signal("was_deselected", self)

func _ready():
	connect("was_selected", get_parent(), "select_unit")
	connect("was_deselected", get_parent(), "deselect_unit")
	box.visible = false
	bar.visible = false
	label.visible = false
	label.text = name
	bar.value = 100

func _process(delta):
	pass

func _on_Unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			set_selected(not selected)
		
		
