extends Area2D
class_name Crystal

func on_crystal_body_entered(body):
	get_tree().call_group("world", "update_crystal", 5)
	destroy()

func destroy():
	queue_free()
