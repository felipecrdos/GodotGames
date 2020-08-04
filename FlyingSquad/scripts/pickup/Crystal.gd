extends Pickup
class_name Crystal

export (PackedScene) var particle
func _ready():
	speed = Vector2(10, 10)

func _physics_process(delta):
	if Global.player:
		direction = Global.player.position - position
		direction *= delta
		position += direction

func on_pickup_body_entered(body):
	get_tree().call_group("world", "update_crystal", 5)
	var new = particle.instance()
	Global.findnode("EffectContainer").call_deferred("add_child", new)
	new.set_deferred("global_position", global_position)
	new.set_deferred("emitting", true)
	destroy()

func destroy():
	queue_free()
