extends Node2D

func _ready():
	Global.setall({"PauseScreen":false, "PauseButtons":false})

func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_P):
			print(name)
			if !Global.find("MenuScreen").visible:
				Global.setall({"PauseScreen":true, "PauseButtons":true})
				Global.set_paused(true)
		
	
