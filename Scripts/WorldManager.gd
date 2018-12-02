#WorldManager.gd
extends Node2D

var selected_units = []
var buttons = []

onready var unit_button = preload("res://Scenes/UnitButton.tscn")

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
		print("Selected %s" % unit.name)
		create_buttons()

func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
		print("Deselected %s" % unit.name)
		create_buttons()
		
func create_buttons():
	delete_buttons()
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = unit_button.instance()
			but.connect_button(self, unit.name)
			but.rect_position = Vector2(buttons.size() * 64 + 32, -70)
			$"UI/Base".add_child(but)
			buttons.append(but.name)
	
func delete_buttons():
	for but in buttons:
		if $"UI/Base".has_node(but):
			var b = $"UI/Base".get_node(but)
			b.queue_free()
			$"UI/Base".remove_child(b)
	buttons.clear()
	
func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break
		
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
