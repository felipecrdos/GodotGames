extends TextureButton

export (String, FILE) var file setget set_file
export (String) var text setget set_text

signal custom_pressed(file)
func set_file(value):
	file = value
	
func set_text(value : String):
	$Label.text = value

func on_custom_button_pressed():
	emit_signal("custom_pressed", file)
