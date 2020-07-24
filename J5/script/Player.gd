extends KinematicBody2D

enum State {IDLE, RUNNING, JUMPING, FALLING, ATTACKING, 
			LANDING, VICTORY, RANDPOSE, DYING}
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
var can_attacking
var is_attacking
var attack_damage
var pose_timer
var face_direction

var max_health
var health setget set_health
func _ready():
	Global.player = self
	funcs_names = [	"idle_state", 
					"running_state", 
					"jumping_state",
					"falling_state",
					"attacking_state",
					"landing_state",
					"victory_state",
					"rand_pose_state",
					"dying_state"]
											#input,hmove,vmove
	funcs_masks = {	State.IDLE		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.ATTACKING	:[true, true, true],
					State.LANDING	:[true, true, true],
					State.VICTORY	:[false, false, false],
					State.RANDPOSE	:[true, true, true],
					State.DYING		:[false, false, false]}
	
	funcs_refs = []
	state = State.RUNNING
	set_funcs_refs(funcs_names)
	
	velocity 	= Vector2(100, 100)
	direction 	= Vector2(0, 1) 
	speed 		= Vector2(100, 19.6)
	jump_force 	= Vector2(0, -400)
	attack_damage = 1
	
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
	is_attacking = false
	randomize()
	
func set_funcs_refs(names):
	for n in names:
		funcs_refs.append(funcref(self, n))

func _physics_process(delta):
	if funcs_masks[state][Func.INPUT]: input()	
	if funcs_masks[state][Func.HMOVE]: hmove() 
	else: velocity.x = 0
	if funcs_masks[state][Func.VMOVE]: vmove()
	else: velocity.y = 0
	
	move()
	funcs_refs[state].call_func(delta)

func input():
	direction.x = 0
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		face_direction = 1
		$ASprite.flip_h = false
		$FireBreath/ASprite.flip_h = false
		$FireBreath.position.x = abs($FireBreath.position.x)
		
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		face_direction = -1
		$ASprite.flip_h = true
		$FireBreath/ASprite.flip_h = true
		$FireBreath.position.x = -abs($FireBreath.position.x)
		
	if Input.is_key_pressed(KEY_E):
		is_attacking = true
	else: is_attacking = false
		
	if Input.is_action_pressed("ui_accept"):
		if can_jump:
			is_jump = true
			
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
	if is_attacking:
		state = State.ATTACKING
		
func running_state(delta): 
	$ASprite.play("Running")
	if !velocity.x && !velocity.y:
		state = State.IDLE	
	if is_jump:
		state = State.JUMPING
	if is_attacking:
		state = State.ATTACKING
		
func jumping_state(delta):
	$ASprite.play("Jumping")
	if can_jump:
		can_jump = false
		velocity.y = jump_force.y
	if velocity.y > 0:
		state = State.FALLING
		
func falling_state(delta):
	$ASprite.play("Falling")
	if is_on_floor():
		state = State.LANDING
		can_jump = true
		is_jump = false

func attacking_state(delta):
	if is_attacking:
		$FireBreath.visible = true
		$FireBreath/ASprite.play("FireBreath")
		Util.enable_monitoring_area_in_frame($FireBreath, $FireBreath/ASprite, 1)
		if velocity.x: 
			$ASprite.play("AttackRun")
		else:
			$ASprite.play("AttackIdle")
	elif !is_attacking:
		$FireBreath.visible = false
		$FireBreath/ASprite.stop()
		$FireBreath.set_deferred("monitoring", false)
		state = State.IDLE
	
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

func dying_state(delta):
	$ASprite.play("Dying")
	yield($ASprite, "animation_finished")
	destroy()
	
func on_pose_timer_timeout():
	if state == State.IDLE:
		state = State.RANDPOSE
		var size = poses_names.size()
		var index = randi()%size
		pose_name = poses_names[index]

func set_health(value):
	print(value)
	health = value
	if health <= 0:
		state = State.DYING

func on_firebreath_body_entered(body):
	body.pushback_force = 100 * face_direction
	body.health -= attack_damage

func destroy():
	queue_free()
