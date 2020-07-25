extends Enemy
class_name EnemyPatrol

enum State {IDLE, WALK, RUNNING, JUMPING, FALLING, 
			CHASE, ATTACK, HURT, DYING}
enum Func {AI, HMOVE, VMOVE, LIMIT}
func _ready():
	funcs_names = [	"idle_state", "walk_state", "running_state",
					"jumping_state", "falling_state", "chase_state",
					"attack_state", "hurt_state", "dying_state"]
					
	funcs_masks = {	State.IDLE		:[true, false, true],
					State.WALK		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.CHASE		:[true, true, true],
					State.ATTACK	:[true, false, false],
					State.HURT		:[true, false, true],
					State.DYING		:[false, false, false]}

	state 		= State.IDLE
	walk_speed 	= 14
	run_speed 	= 22
	attack_damage = 2
	frame_attack = 3
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
		$ASprite.flip_h = false
		$ASprite/HitBoxArea.position.x = abs($ASprite/HitBoxArea.position.x)
	if direction.x < 0:
		$ASprite.flip_h = true
		$ASprite/HitBoxArea.position.x = -abs($ASprite/HitBoxArea.position.x)
func hmove():
	velocity.x = direction.x * hspeed

func vmove():
	velocity.y += gravity * vspeed
	
func move():
	velocity = move_and_slide(velocity, Vector2.UP)

func idle_state(delta):
	$ASprite.play("Idle")
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
	
func walk_state(delta):
	$ASprite.play("Walking")
	hspeed = walk_speed
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
		
	if is_on_wall():
		state = State.IDLE
		
func running_state(delta):
	$ASprite.play("Running")
	hspeed = run_speed
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
		
	if is_on_wall():
		state = State.IDLE

func jumping_state(delta):
	$ASprite.play("Jumping")

func falling_state(delta):
	$ASprite.play("Falling")
	
func chase_state(delta):
	$ASprite.play("Running")
	hspeed = run_speed
	if Util.check_area_collision($AttackArea, Global.player):
		state = State.ATTACK
	if !Util.check_area_collision($ChaseArea, Global.player) || !Global.player:
		state = State.IDLE
	if Global.player:
		direction.x = sign(target.global_position.x - global_position.x)
		
func attack_state(delta):
	$ASprite.play("Attacking")
	if Global.player:
		direction.x = sign(target.global_position.x - global_position.x)
	if $ASprite.frame == frame_attack:
		if Util.check_area_collision($ASprite/HitBoxArea, Global.player):
			Global.player.health -= attack_damage
			print(Global.player.health)
			$ASprite/HitBoxArea.set_deferred("monitoring", false)
			
	yield($ASprite, "animation_finished")
	$ASprite/HitBoxArea.set_deferred("monitoring", true)
	
	if !Util.check_area_collision($AttackArea, Global.player) || !Global.player:
		state = State.IDLE
	
func hurt_state(delta):
	$ASprite.play("Hurt")
	velocity.x += pushback
	pushback = lerp(pushback, 0, 0.1)
	yield($ASprite, "animation_finished")
	if health <= 0:
		state = State.DYING
	else:
		state = State.IDLE
	
func dying_state(delta):
	$ASprite.play("Dying")
	yield($ASprite, "animation_finished")
	destroy()
		
func on_change_state_timeout():
	randomize()
	match state:
		State.IDLE, State.WALK, State.RUNNING:
			var states = [State.IDLE,State.WALK,State.RUNNING]
			var size = states.size()
			var index = randi()%size
			state = states[index]
			direction.x = Util.choose([-1, 1])
	
func set_health(value):
	health = value
	state = State.HURT
		
func destroy():
	queue_free()

