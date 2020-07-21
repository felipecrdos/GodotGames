extends KinematicBody2D

enum State{	IDLE, 
			RUNNING, 
			JUMPING, 
			FALLING, 
			LANDING,
			HITTING,
			DYING }
			
var func_mask_input = [true, true, true, true, true, false, false]
var func_mask_move = [true, true, true, true, true, false, false]
 
var namefuncs = ["idle_state",
				 "running_state",
				 "jumping_state",
				 "falling_state",
				 "landing_state",
				 "hitting_state",
				 "dying_state"]
var funcsrefs = []
var state = State.RUNNING

var velocity = Vector2.ZERO
var direction = Vector2(0, 1)
var speed = Vector2(100, 800)

var jump_force 	: float = 300
var can_jump 	: bool = false
var is_jumping 	: bool = false

func _ready():
	set_funcsrefs()
	pass
	
func _physics_process(delta):
	if func_mask_input[state]:
		input()
	if func_mask_move[state]:
		move(delta)
		
	funcsrefs[state].call_func(delta)

func set_funcsrefs():
	for n in namefuncs:
		funcsrefs.append(funcref(self, n))

func input():
	direction.x = 0
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1 
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			can_jump = true
			is_jumping = true
	
func move(delta):
	velocity.y += direction.y * speed.y * delta
	velocity.x = direction.x * speed.x
	velocity = move_and_slide(velocity, Vector2.UP)
	
func idle_state(delta):
	if velocity.x:
		state = State.RUNNING
	if velocity.y < 0:
		state = State.JUMPING
		direction.y = 1
	if is_jumping:
		state = State.JUMPING
		
func running_state(delta):
	if !velocity.x && !velocity.y:
		state = State.IDLE
	if is_jumping:
		state = State.JUMPING
		
func jumping_state(delta):
	if can_jump:
		velocity.y = -jump_force
		can_jump = false
	if is_on_floor():
		state = State.IDLE
		is_jumping = false
		
func falling_state(delta):
	pass
func landing_state(delta):
	pass
func hitting_state(delta):
	pass
func dying_state(delta):
	pass
