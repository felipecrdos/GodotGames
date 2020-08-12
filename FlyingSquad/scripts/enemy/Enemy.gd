extends Area2D
class_name Enemy

var velocity : Vector2
var direction : Vector2
var speed : Vector2
var crystals : int
var damage : int
var health : int
onready var crystal = preload("res://scenes/pickup/Crystal.tscn")
onready var explosion = preload("res://scenes/effect/Explosion.tscn")

func _ready():
	velocity = Vector2.ZERO
	direction = Vector2.DOWN
	speed = Vector2(100, 100)
	crystals = 0
	damage = 1
	health = 5
	
func destroy():
	for i in crystals:
		Global.create_crystal(crystal, position)
	queue_free()
	
func on_enemy_body_entered(body):
	Global.create_explosion(explosion, position, "puff", Vector2(2, 2))
	get_tree().call_group("world","update_health",-damage, body)
	destroy()

func on_enemy_area_entered(area):
	health -= area.damage
	if health <= 0:
		Global.create_explosion(explosion, position, "puff", Vector2(2, 2))
		destroy()

