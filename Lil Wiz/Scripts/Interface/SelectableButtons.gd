extends Node2D

var index = 0
var count = 0
var change = false

func _ready():
	count = get_child_count()
	set_focus(index)

func _process(delta):
	if Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_down"):
		index += 1
		change = true
	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_up"):
		index -= 1
		change = true
		
	index = wrapi(index, 0, count)
	if change:
		set_focus(index)
		change = false

func set_focus(index : int):
	var button = get_child(index)
	if button && button is Control:
		button.grab_focus()
