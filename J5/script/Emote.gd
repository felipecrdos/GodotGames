extends Node2D

var velocity = Vector2(0, -50)

func play_emote(emote):
	$ASprite.play("Angry")
	
func _physics_process(delta):
	position += velocity * delta
	modulate.a -= 0.01
	if modulate.a <= 0:
		queue_free()
