extends Node2D

func _ready():
	pass

func on_start_send_scene(scene):
	get_tree().change_scene(scene)
	
func on_quit_send_scene(scene):
	get_tree().change_scene(scene)
