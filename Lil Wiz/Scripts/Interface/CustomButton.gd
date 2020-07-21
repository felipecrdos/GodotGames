extends Button

export (String, FILE) var file
signal custom_pressed(file)

func on_custom_button_pressed():
	emit_signal("custom_pressed", file)
