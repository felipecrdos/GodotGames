extends Node2D

signal change_level(file)
signal resume_level(file)
signal goto_menu(file)

func init():
	pass

func _ready():	
	init()
	
func change_level(file):
	load_level(file)
	
func load_level(file):
	remove_level()
	call_deferred("add_child",load(file).instance())
	
func remove_level():
	if has_node("Level"):
		get_node("Level").call_deferred("free")

func on_start_button_pressed(file):
	emit_signal("change_level", file)

func on_menu_button_pressed(file):
	emit_signal("goto_menu", file)

func on_resume_button_pressed(file):
	emit_signal("resume_level", file)
