extends Area2D
class_name Ammo

var direction : Vector2 setget set_direction
var velocity : Vector2 setget set_velocity
var speed : Vector2 setget set_speed
var angle : float setget set_angle

func set_direction(value:Vector2):
	direction = value
	rotation = direction.angle()
	
func set_velocity(value:Vector2):
	velocity = value
	
func set_speed(value:Vector2):
	speed = value

func set_angle(value:float):
	angle = value
	angle = wrapf(angle, -PI, PI)
	
func on_notifier_screen_exited():
	queue_free()
