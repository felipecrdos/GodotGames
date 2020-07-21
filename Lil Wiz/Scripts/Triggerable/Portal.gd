extends Node2D

export (PackedScene) var scene
signal entered_portal(body, scene)

func _ready():
	pass


func on_area_body_entered(body):
	emit_signal("entered_portal", body, scene)
	
	pass 
