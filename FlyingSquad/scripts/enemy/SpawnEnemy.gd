extends Position2D

export (PackedScene) var enemy
var screen_width
var screen_height

func _ready():
	screen_width = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	print("screen width: ", screen_width)
	
func on_timer_timeout():
	randomize()
	var px = rand_range(0, screen_width)
	var py = -100
	var new = enemy.instance()
	Global.findnode("ActorContainer").call_deferred("add_child", new)
	new.set_deferred("position", Vector2(px, py))
