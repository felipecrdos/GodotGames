extends Node2D

export (String) var change_to

func _ready():
	pass


func on_area_body_entered(body):
	print("body name: ", body.name)
	print("go to: ", change_to)
	pass 
