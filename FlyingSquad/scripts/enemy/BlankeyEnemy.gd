extends Enemy

func _ready():
	$ASprite.play("flying")
	crystals = 2
	
func _physics_process(delta):
	velocity = direction * speed * delta
	position += velocity
