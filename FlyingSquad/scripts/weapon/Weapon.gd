extends Position2D

export (float) var fire_rate setget set_fire_rate
export (PackedScene) var ammo setget set_ammo
var start_fire_rate : float
	
func set_fire_rate(value:float):
	if value >= 0:
		fire_rate = value
		start_fire_rate = fire_rate

func set_ammo(value:PackedScene):
	ammo = value
	
func shoot(dir:=Vector2.ZERO, speed:=Vector2.ZERO):
	fire_rate -= 1
	if fire_rate <= 0:
		var new_ammo = ammo.instance()
		new_ammo.set_deferred("direction", dir)
		new_ammo.set_deferred("speed", speed)
		new_ammo.set_deferred("global_position", global_position)
		Global.findnode("AmmoContainer").call_deferred("add_child", new_ammo)
		fire_rate = start_fire_rate
