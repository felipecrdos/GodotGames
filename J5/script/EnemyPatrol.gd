extends Enemy
class_name EnemyPatrol

enum State {IDLE, WALK, RUNNING, JUMPING, FALLING, 
			CHASE, ATTACK, HURT, PUSHBACK, DYING}
enum Func {AI, HMOVE, VMOVE}

func _ready():
	funcs_names = [	"idle_state", "walk_state", "running_state",
					"jumping_state", "falling_state", "chase_state",
					"attack_state", "hurt_state", "pushback_state",
					"dying_state"]
					
	funcs_masks = {	State.IDLE		:[true, false, true],
					State.WALK		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.CHASE		:[true, true, true],
					State.ATTACK	:[true, false, false],
					State.HURT		:[true, true, true],
					State.PUSHBACK	:[true, true, true],
					State.DYING		:[true, true, true]}

	state 	= State.IDLE
	walk_speed = 14
	run_speed = 22
	set_funcs_refs()
	
func _physics_process(delta):
	if funcs_masks[state][Func.AI]:ai()
	if funcs_masks[state][Func.HMOVE]:hmove()
	else: velocity.x = 0
	if funcs_masks[state][Func.VMOVE]:vmove()
	else: velocity.y = 0
	
	funcs_refs[state].call_func(delta)
	move()

func ai():
	if direction.x > 0:
		animation.flip_h = false
		hitbox_area.position.x = abs(hitbox_area.position.x)  
	if direction.x < 0:
		animation.flip_h = true
		hitbox_area.position.x = -abs(hitbox_area.position.x)

func hmove():
	velocity.x = direction.x * hspeed

func vmove():
	velocity.y += gravity * vspeed
	
func move():
	velocity = move_and_slide(velocity, Vector2.UP)

func idle_state(delta):
	animation.play("Idle")
	
func walk_state(delta):
	animation.play("Walking")
	hspeed = walk_speed
	
func running_state(delta):
	animation.play("Running")
	hspeed = run_speed

func jumping_state(delta):
	animation.play("Jumping")

func falling_state(delta):
	animation.play("Falling")
	
func chase_state(delta):
	animation.play("Running")
	hspeed = run_speed
	direction.x = sign(Global.player.global_position.x - global_position.x)
		
func attack_state(delta):
	animation.play("Attacking")
	direction.x = sign(Global.player.global_position.x - global_position.x)
	Util.enable_monitoring_area_in_frame(hitbox_area, animation, 3)
	
func hurt_state(delta):
	animation.play("Hurt")
	
func dying_state(delta):
	animation.play("Dying")

func on_change_state_timeout():
	randomize()
	match state:
		State.IDLE, State.WALK, State.RUNNING:
			var states = [State.IDLE,State.WALK,State.RUNNING]
			var size = states.size()
			var index = randi()%size
			state = states[index]
			direction.x = Util.choose([-1, 1])

func on_chase_area_body_entered(body):
	if state != State.CHASE && state != State.ATTACK:
		state = State.CHASE
	
func on_chase_area_body_exited(body):
	state = State.IDLE

func on_attack_area_body_entered(body):
	if state != State.ATTACK:
		state = State.ATTACK
		
func on_attack_area_body_exited(body):
	state = State.CHASE

func on_hitbox_body_entered(body):
	print("hiting entered: ", body.name)
	
func on_hitbox_body_exited(body):
	print("hiting exit: ", body.name)
	hitbox_area.set_deferred("monitoring", false)