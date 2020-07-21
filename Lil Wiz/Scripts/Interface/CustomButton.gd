extends Button

export (String, FILE) var scene
signal custom_pressed

func on_custom_button_pressed():
	emit_signal("custom_pressed", scene)
