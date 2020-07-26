extends KinematicBody2D

enum State {IDLE, RUNNING, JUMPING, FALLING, 
			LANDING, VICTORY, RANDPOSE, HURT, DYING}
enum Attack {ATTACK_ONE, ATTACK_TWO, ATTACK_THREE}
enum Func {INPUT, HMOVE, VMOVE}
var poses_names
var pose_name
var funcs_names
var funcs_refs
var funcs_masks
var state

var velocity
var direction
var speed
var jump_force
var can_jump
var is_jump
var in_air
var pushback
var pose_timer
var face
var can_attacking
var attack_damage
var attack_force
var is_attacking : Array

var max_health
var health setget set_health
func _ready():
	Global.player = self
	funcs_names = [	"idle_state", 
					"running_state", 
					"jumping_state",
					"falling_state",
					"landing_state",
					"victory_state",
					"rand_pose_state",
					"hurt_state",
					"dying_state"]
											#input,hmove,vmove
	funcs_masks = {	State.IDLE		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.LANDING	:[true, true, true],
					State.VICTORY	:[false, false, false],
					State.RANDPOSE	:[true, true, true],
					State.HURT		:[false, false, true],
					State.DYING		:[false, false, true]}
	
	funcs_refs = []
	state = State.RUNNING
	set_funcs_refs(funcs_names)
	
	velocity 	= Vector2(100, 100)
	direction 	= Vector2(0, 1) 
	speed 		= Vector2(100, 19.6)
	jump_force 	= Vector2(0, -400)
	attack_damage = 1
	attack_force = 300
	pushback = 100
	
	poses_names = [	"Laughing", 
					"Around",
					"Miscell",
					"Lookingup"]
	
	max_health	= 10
	health		= max_health
	
	can_jump 	= true
	is_jump 	= false
	in_air 		= false
	
	can_attacking = true
	is_attacking.resize(3)
	is_attacking[Attack.ATTACK_ONE] 	= false
	is_attacking[Attack.ATTACK_TWO] 	= false
	is_attacking[Attack.ATTACK_THREE] 	= false
	randomize()
	
func set_funcs_refs(names):
	for n in names:
		funcs_refs.append(funcref(self, n))

func _physics_process(delta):
	if funcs_masks[state][Func.INPUT]: input()	
	if funcs_masks[state][Func.HMOVE]: hmove() 
	if funcs_masks[state][Func.VMOVE]: vmove()
	
	move()
	update_attack()
	funcs_refs[state].call_func(delta)

func input():
	direction.x = 0
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		$ASprite.flip_h = false
		$AttackOne/ASprite.flip_h = false
		$AttackOne.position.x = abs($AttackOne.position.x)
		
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
		$ASprite.flip_h = true
		$AttackOne/ASprite.flip_h = true
		$AttackOne.position.x = -abs($AttackOne.position.x)
	face = -1 if $ASprite.flip_h else 1
	
	if Input.is_action_pressed("ui_accept"):
		if can_jump:
			is_jump = true
			
	is_attacking[Attack.ATTACK_ONE] 	= false
	is_attacking[Attack.ATTACK_TWO] 	= false
	is_attacking[Attack.ATTACK_THREE] 	= false
	if Input.is_key_pressed(KEY_1):
		is_attacking[Attack.ATTACK_ONE] = true
	if Input.is_key_pressed(KEY_2):
		is_attacking[Attack.ATTACK_TWO] = true
	if Input.is_key_pressed(KEY_3):
		is_attacking[Attack.ATTACK_THREE] = true
	
func hmove():
	velocity.x = direction.x * speed.x
	
func vmove():
	velocity.y += direction.y * speed.y

func move():
	velocity = move_and_slide(velocity, Vector2.UP)

func idle_state(delta):
	$ASprite.play("Idle")
	if velocity.x:
		state = State.RUNNING
	if is_jump:
		state = State.JUMPING

func running_state(delta): 
	$ASprite.play("Running")
	if !velocity.x && !velocity.y:
		state = State.IDLE	
	if is_jump:
		state = State.JUMPING
		
func jumping_state(delta):
	$ASprite.play("Jumping")
	if can_jump:
		can_jump = false
		velocity.y = jump_force.y
	if velocity.y > 0:
		state = State.FALLING
	
	if is_on_floor():
		state = State.LANDING
		
func falling_state(delta):
	$ASprite.play("Falling")
	if is_on_floor():
		state = State.LANDING
		can_jump = true
		is_jump = false

func landing_state(delta):
	if !velocity.x:
		state = State.IDLE
	if velocity.x:
		state = State.RUNNING

func rand_pose_state(delta):
	$ASprite.play(pose_name)
	if velocity.x:
		state = State.RUNNING
	if is_jump:
		state = State.JUMPING
	yield($ASprite, "animation_finished")
	state = State.IDLE

func hurt_state(delta):
	$ASprite.play("Hurt")
	velocity.x += pushback
	velocity.y -= abs(pushback) * 2
	pushback = lerp(pushback, 0, 0.4)
	
	if health <= 0:
		state = State.DYING
		
	if abs(pushback) < 0.001:
		state = State.IDLE
		
func dying_state(delta):
	$ASprite.play("Dying")
	velocity.x = 0
	velocity.y = 0
	collision_layer = 0
	yield($ASprite, "animation_finished")
	destroy()

func update_attack():
	attacking_one()
	attacking_two()
	attacking_three()

func attacking_one():
	if is_attacking[Attack.ATTACK_ONE]:
		$AttackOne/ASprite.visible = true
		$AttackOne/ASprite.play("AttackOne")
		
		if $AttackOne.monitoring && $AttackOne/ASprite.frame == 1:
			for body in $AttackOne.get_overlapping_bodies():
				if Util.check_area_collision($AttackOne, body):
					if body is Enemy:
						body.pushback = attack_force * face
						body.health -= attack_damage
					$AttackOne.set_deferred("monitoring", false)

	elif !is_attacking[Attack.ATTACK_ONE]:
		$AttackOne/ASprite.visible = false
		$AttackOne/ASprite.stop()

func attacking_two():
	if is_attacking[Attack.ATTACK_TWO]:
		$AttackTwo/ASprite.visible = true
		$AttackTwo/ASprite.play("AttackTwo")
		
		if $AttackTwo.monitoring && $AttackTwo/ASprite.frame%2 == 0:
			for body in $AttackTwo.get_overlapping_bodies():
				if Util.check_area_collision($AttackTwo, body):
					if body is Enemy:
						var tdir = Util.target_hdirect(body, self)
						body.pushback = float(attack_force * tdir)
						body.health -= attack_damage
					$AttackTwo.set_deferred("monitoring", false)
	elif !is_attacking[Attack.ATTACK_TWO]:
		$AttackTwo/ASprite.visible = false
		$AttackTwo/ASprite.stop()

func attacking_three():
	if is_attacking[Attack.ATTACK_THREE]:
		$AttackThree/ASprite.visible = true
		$AttackThree/ASprite.play("AttackThree")
		
		if $AttackThree.monitoring && $AttackThree/ASprite.frame == 1:
			for body in $AttackThree.get_overlapping_bodies():
				if Util.check_area_collision($AttackThree, body):
					if body is Enemy:
						body.pushback = 100 * face
						body.health -= attack_damage
					$AttackThree.set_deferred("monitoring", false)
	
	elif !is_attacking[Attack.ATTACK_THREE]:
		$AttackThree/ASprite.visible = false
		$AttackThree/ASprite.stop()

func on_pose_timer_timeout():
	if state == State.IDLE:
		state = State.RANDPOSE
		var size = poses_names.size()
		var index = randi()%size
		pose_name = poses_names[index]

func set_health(value):
	health = value
	velocity.x = 0
	velocity.y = 0
	if state != State.DYING:
		state = State.HURT

func destroy():
	Efx.create_effect("FireExplosion", global_position, Vector2(2, 2))
	queue_free()

func on_attackone_animation_finished():
	$AttackOne.set_deferred("monitoring", true)
func on_attacktwo_animation_finished():
	$AttackTwo.set_deferred("monitoring", true)
func on_attackthree_animation_finished():
	$AttackThree.set_deferred("monitoring", true)
