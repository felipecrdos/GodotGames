extends Node2D

var btn_resume

func _ready():
	btn_resume = get_node("ResumeButton")

func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_P):
			get_tree().paused = true
			visible = get_tree().paused
