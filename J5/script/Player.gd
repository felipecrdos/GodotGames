extends KinematicBody2D

enum State {IDLE, RUNNING, JUMPING, FALLING, LANDING, VICTORY, POSE}
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

var animation
var pose_timer
func _ready():
	funcs_names = [	"idle_state", 
					"running_state", 
					"jumping_state",
					"falling_state",
					"landing_state",
					"victory_state",
					"pose_state"]
											#input,hmove,vmove
	funcs_masks = {	State.IDLE		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.LANDING	:[true, true, true],
					State.VICTORY	:[false, false, false],
					State.POSE		:[true, true, true]}
	
	funcs_refs = []
	state = State.RUNNING
	set_funcs_refs(funcs_names)
	
	velocity 	= Vector2(100, 100)
	direction 	= Vector2(0, 1) 
	speed 		= Vector2(100, 19.6)
	jump_force 	= Vector2(0, -400)
	
	animation 	= $ASprite
	pose_timer 	= $PoseTimer
	poses_names = [	"Laughing", 
					"Around",
					"Miscell",
					"Lookingup"]

	can_jump 	= true
	is_jump 	= false
	in_air 		= false
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
		animation.flip_h = false
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animation.flip_h = true
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
	animation.play("Idle")
	if velocity.x:
		state = State.RUNNING
	if is_jump:
		state = State.JUMPING
	
func running_state(delta): 
	animation.play("Running")
	if !velocity.x && !velocity.y:
		state = State.IDLE	
	if is_jump:
		state = State.JUMPING
		
func jumping_state(delta):
	animation.play("Jumping")
	if can_jump:
		can_jump = false
		velocity.y = jump_force.y
	if velocity.y > 0:
		state = State.FALLING
		
func falling_state(delta):
	animation.play("Falling")
	if is_on_floor():
		state = State.LANDING
		can_jump = true
		is_jump = false
	
func landing_state(delta):
	if !velocity.x:
		state = State.IDLE
	if velocity.x:
		state = State.RUNNING

func pose_state(delta):
	animation.play(pose_name)
	if velocity.x:
		state = State.RUNNING
	if is_jump:
		state = State.JUMPING
	yield(animation, "animation_finished")
	state = State.IDLE

func on_pose_timer_timeout():
	if state == State.IDLE:
		state = State.POSE
		var size =poses_names.size()
		var index = randi()%size
		pose_name = poses_names[index]

