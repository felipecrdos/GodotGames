extends Node2D

var vcontainer
var screen_size
var screen_pos

func _ready():
	vcontainer  = $VContainer
	screen_size = get_viewport_rect().size
	screen_pos  = get_viewport_rect().position 


func on_start_send_scene(scene):
	get_tree().change_scene(scene)
	
