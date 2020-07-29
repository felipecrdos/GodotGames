extends Camera2D

var shake_time : int
var shake_remain : float
var shake_force : float
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	
	if shake_remain > 0.0:
		position.x = rand_range(shake_remain, -shake_remain)
		position.y = rand_range(shake_remain, -shake_remain)
		
		shake_remain = max(0, shake_remain - ((1.0/float(shake_time))) * shake_force)
		
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
func shake(force, time):
	if force > shake_remain:
		shake_force = force
		shake_remain = force
		if time > 0:
			shake_time = time
