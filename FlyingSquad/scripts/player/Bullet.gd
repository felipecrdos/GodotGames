extends Ammo

func _ready():
	speed = Vector2(400, 400)

func _physics_process(delta):
	velocity = direction * speed * delta
	global_position += velocity


