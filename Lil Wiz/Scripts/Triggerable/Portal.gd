extends Node2D

export (String, FILE) var scene
signal entered_portal(body, scene)

func on_area_body_entered(body):
	emit_signal("entered_portal", body, scene)
	$Area/Shape.set_deferred("disabled", true)
