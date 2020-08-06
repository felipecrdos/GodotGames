extends Pickup
class_name Crystal

func _ready():
	speed = Vector2(10, 10)

func _physics_process(delta):
	if Global.player:
		direction = Global.player.position - position
		direction *= delta
		position += direction

func on_pickup_body_entered(body):
	get_tree().call_group("world", "update_crystal", 5)
	destroy()

func destroy():
	Global.create_popup(popup, position, str(5), Color.chartreuse)
	Global.create_particle(particle, position, Color.chartreuse)
	queue_free()
