extends Node2D

signal change_level

func init():
	pass

func _ready():	
	init()
	
func change_level(scene):
	load_level(scene)
	
func load_level(scene):
	remove_level()
	call_deferred("add_child",load(scene).instance())
	
func remove_level():
	if has_node("Level"):
		get_node("Level").call_deferred("free")

func on_start_button_pressed(scene):
	emit_signal("change_level", scene)

