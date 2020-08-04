extends Position2D
class_name Barrel

export (PackedScene) var ammo

func shoot():
	var new = ammo.instance()
	new.set_deferred("global_position", global_position)
	new.set_deferred("direction", Vector2(cos(rotation),sin(rotation)))
	Global.findnode("AmmoContainer").call_deferred("add_child", new)

