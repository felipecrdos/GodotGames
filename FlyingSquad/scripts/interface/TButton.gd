extends TextureButton

export (String, FILE) var scene
signal send_scene(scene)

func _ready():
	grab_focus()
	
func on_texture_button_pressed():
	emit_signal("send_scene", scene)
