extends KinematicBody2D
class_name Enemy

var velocity
var direction
var walk_speed
var run_speed
var frame_attack
var pushback
var gravity
var vspeed
var hspeed
var state
var funcs_names
var funcs_masks
var funcs_refs
var attack_damage
var target
var max_health
var health setget set_health

func _ready():
	velocity  	= Vector2.ZERO
	direction 	= Vector2.ZERO
	walk_speed 	= 8 
	run_speed 	= 16
	gravity		= 0
	max_health 	= 10
	frame_attack = 0
	vspeed		= 1
	pushback = 10
	hspeed		= walk_speed
	health 		= max_health
	target		= Global.player
	funcs_refs = []
	
func set_funcs_refs():
	for nam in funcs_names:
		funcs_refs.append(funcref(self, nam))

func set_health(value):
	pass


func on_hitbox_area_body_entered(body):
	pass # Replace with function body.

func on_chase_area_body_entered():
	pass # Replace with function body.

func on_attack_area_body_entered():
	pass # Replace with function body.

func on_chase_area_body_exit():
	pass # Replace with function body.

func on_attack_area_body_exit():
	pass # Replace with function body.

func on_hitbox_area_body_exit(body):
	pass # Replace with function body.
