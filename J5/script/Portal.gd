extends Area2D

export (PackedScene) var scene 
signal player_entering_portal(scene)

func on_portal_body_entered(body):
	print("on_portal_body_entered", body.name)
	emit_signal("player_entering_portal", scene)
