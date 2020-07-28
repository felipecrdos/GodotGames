extends Ammo

func _physics_process(delta):
	velocity = direction * speed * delta
	global_position += velocity


