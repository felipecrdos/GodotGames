extends KinematicBody2D
class_name Enemy

var velocity
var direction
var walk_speed
var run_speed
var frame_attack
var pushback_force
var gravity
var vspeed
var hspeed
var health
var max_health
var state
var animation
var hitbox_area
var funcs_names
var funcs_masks
var funcs_refs

func _ready():
	animation	= $ASprite
	hitbox_area = $ASprite/HitBoxArea
	velocity  	= Vector2.ZERO
	direction 	= Vector2.ZERO
	walk_speed 	= 8 
	run_speed 	= 16
	gravity		= 0
	max_health 	= 10
	frame_attack = 0
	vspeed		= 1
	pushback_force = 10
	hspeed		= walk_speed
	health 		= max_health
	
	funcs_refs = []
	
func set_funcs_refs():
	for nam in funcs_names:
		funcs_refs.append(funcref(self, nam))

