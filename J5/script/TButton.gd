extends TextureButton
export (PackedScene) var scene
signal send_scene(scene)

func _ready():
	grab_focus()
		
func on_tbutton_pressed():
	emit_signal("send_scene", scene)
