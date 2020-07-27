extends KinematicBody2D
class_name Enemy

var velocity
var direction
var frame_attack
var pushback
var vspeed
var hspeed
var state
var funcs_names
var funcs_masks
var funcs_refs
var attack_damage
var attack_force
var max_health
var sposition
var face
var health setget set_health

func _ready():
	velocity  	= Vector2.ZERO
	direction 	= Vector2.ZERO
	max_health 	= 10
	frame_attack = 0
	attack_force = 100
	vspeed		= 1
	hspeed		= 8
	pushback = 10
	health 		= max_health
	funcs_refs = []
	
func set_health(value):
	pass

func set_funcs_refs():
	for nam in funcs_names:
		funcs_refs.append(funcref(self, nam))

