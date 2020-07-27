extends Node

func _ready():
	
	pass



func on_timer_timeout():
	get_tree().change_scene("res://scenes/Menu.tscn")
