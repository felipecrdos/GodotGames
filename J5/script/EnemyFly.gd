extends Enemy
class_name EnemyFly

enum State {IDLE, HOME, FLYING, CHASE, ATTACK, HURT, DYING}
enum Func {AI, HMOVE, VMOVE, LIMIT}
var angle
var time
var radius

func _ready():
	funcs_names = [	"idle_state", "home_state", "flying_state", "chase_state" ,
					"attack_state", "hurt_state", "dying_state"]
					
	funcs_masks = {	State.IDLE		:[true, false, true],
					State.HOME		:[true, true, true],
					State.FLYING	:[true, true, true],
					State.CHASE		:[true, true, true],
					State.ATTACK	:[true, false, true],
					State.HURT		:[false, false, true],
					State.DYING		:[false, false, false]}

	state 		= State.IDLE
	walk_speed 	= 14
	run_speed 	= 22
	attack_damage = 2
	frame_attack = 3
	angle		 = 0
	radius		 = 30
	hspeed		 = 10
	vspeed		 = 1
	time = 1
	
	set_funcs_refs()

func _physics_process(delta):
	if funcs_masks[state][Func.AI]:ai(delta)
	if funcs_masks[state][Func.HMOVE]:hmove(delta)
	else: velocity.x = 0
	if funcs_masks[state][Func.VMOVE]:vmove(delta)
	else: velocity.y = 0
	
	funcs_refs[state].call_func(delta)
	bodyarea_collision()
	update_angle(delta)
	move(delta)

func ai(delta):
	if direction.x > 0:
		face = direction.x
		$ASprite.flip_h = false
		$ASprite/HitBoxArea.position.x = abs($ASprite/HitBoxArea.position.x)
	if direction.x < 0:
		face = direction.x
		$ASprite.flip_h = true
		$ASprite/HitBoxArea.position.x = -abs($ASprite/HitBoxArea.position.x)
	face = -1 if $ASprite.flip_h else 1
	
func hmove(delta):
	velocity.x = direction.x * hspeed

func vmove(delta):
	velocity.y = (sin(angle) * radius * delta) + position.y
	velocity.y += direction.y * vspeed

func update_angle(delta):
	angle += (2*PI * delta) / time
	angle = wrapf(angle, -PI, PI)
	
func move(delta):
	position.x += velocity.x * delta
	position.y = velocity.y

func idle_state(delta):
	$ASprite.play("Idle")
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
	direction.y = 0

func home_state(delta):
	$ASprite.play("Flying")
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
	
	var distx = sposition.x - global_position.x
	var disty = sposition.y - global_position.y
	if abs(distx) > 10:
		direction.x = sign(distx)
	else: direction.x = 0
	if abs(disty) > 10:
		direction.y = sign(disty)
	else: direction.y = 0
	if !direction.x && !direction.y:
		state = State.IDLE
	

func flying_state(delta):
	$ASprite.play("Flying")
	if Util.check_area_collision($ChaseArea, Global.player):
		state = State.CHASE
	
func chase_state(delta):
	$ASprite.play("Flying")
	hspeed = run_speed
	if Util.check_area_collision($AttackArea, Global.player):
		state = State.ATTACK
	if !Util.check_area_collision($ChaseArea, Global.player) || !Global.player:
		state = State.HOME
		$ChangeStateTimer.start()
		
	if Global.player:
		var distx = Global.player.global_position.x - global_position.x
		var disty = Global.player.global_position.y - global_position.y
		if abs(distx) > 1:
			direction.x = sign(distx)
		if disty > 25:
			direction.y = sign(disty)
		else: direction.y = 0

func attack_state(delta):
	$ASprite.play("Attacking")
	if Global.player:
		direction.x = sign(target.global_position.x - global_position.x)
	if $ASprite.frame == frame_attack:
		if Util.check_area_collision($ASprite/HitBoxArea, Global.player):
			var tdir = Util.hdirect(self, Global.player)
			Global.player.pushback = float(attack_force * tdir)
			Global.player.health -= attack_damage
			Sound.play_sfx("hit2")
			$ASprite/HitBoxArea.set_deferred("monitoring", false)
			
	yield($ASprite, "animation_finished")
	$ASprite/HitBoxArea.set_deferred("monitoring", true)
	
	if !Util.check_area_collision($AttackArea, Global.player) || !Global.player:
		state = State.CHASE
	
func hurt_state(delta):
	if health > 0:
		$ASprite.play("Hurt")
		velocity.x += pushback
		pushback = lerp(pushback, 0, 0.2)

	if health <= 0:
		state = State.DYING
	if abs(pushback) < 0.01:
		state = State.IDLE
	
func dying_state(delta):
	$ASprite.play("Dying")
	yield($ASprite, "animation_finished")
	destroy()
		
func on_change_state_timeout():
	randomize()
	match state:
		State.IDLE, State.FLYING, State.HOME:
			var states = [State.IDLE, State.FLYING, State.HOME]
			var size = states.size()
			var index = randi()%size
			state = states[index]
			direction.x = Util.choose([-1, 1])
	
func set_health(value):
	health = value
	state = State.HURT

func bodyarea_collision():
	if state != State.HURT && Global.player:
		if Util.check_area_collision($BodyArea, Global.player):
			Global.player.pushback = float(attack_force * face)
			Global.player.health -= attack_damage
			Sound.play_sfx("hit2")
			$BodyArea.set_deferred("monitoring", false)
		elif state != State.ATTACK: 
			$BodyArea.set_deferred("monitoring", true)
	
func destroy():
	Efx.create_effect("SmokeExplosion",global_position, Vector2(2, 2))
	Sound.play_sfx("balloon_pop")
	queue_free()

