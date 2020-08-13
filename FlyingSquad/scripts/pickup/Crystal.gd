extends Pickup
class_name Crystal

var target : Vector2
func _ready():
	var tx = rand_range(position.x, position.x + 200)
	var ty = rand_range(position.y - 40, position.y - 80)
	target = Vector2(tx, ty)
	speed = Vector2(10, 10)
	value = "5"

func _physics_process(delta):
	direction = target - position
	direction *= delta
	position += direction

func on_pickup_body_entered(body):
	get_tree().call_group("world", "update_crystal", 5)
	destroy()

func destroy():
	Global.create_popup(popup, position, value, Color.chartreuse)
	Global.create_particle(particle, position, Color.chartreuse)
	queue_free()

func on_timer_timeout():
	if Global.player:
		target = Global.player.position
		$Timer.wait_time = 0.1
