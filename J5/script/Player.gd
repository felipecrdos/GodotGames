extends KinematicBody2D

enum State {IDLE, RUNNING, JUMPING, FALLING, LANDING}
enum Func {INPUT, HMOVE, VMOVE}

var funcs_names
var funcs_refs
var funcs_masks
var state

var velocity
var direction
var speed

func _ready():
	funcs_names = [	"idle_state", 
					"running_state", 
					"jumping_state",
					"falling_state",
					"landing_state"]
											#input,hmove,vmove
	funcs_masks = {	State.IDLE		:[true, true, true],
					State.RUNNING	:[true, true, true],
					State.JUMPING	:[true, true, true],
					State.FALLING	:[true, true, true],
					State.LANDING	:[true, true, true]}
	
	funcs_refs = []
	state = State.RUNNING
	set_funcs_refs(funcs_names)
	
	velocity = Vector2(100, 100)
	direction = Vector2(0, 1) 
	speed = Vector2(100, 9.8)

func set_funcs_refs(names):
	for n in names:
		funcs_refs.append(funcref(self, n))

func _physics_process(delta):
	if funcs_masks[state][Func.INPUT]: input()	
	if funcs_masks[state][Func.HMOVE]: hmove() 
	else: velocity.x = 0
	if funcs_masks[state][Func.VMOVE]: vmove()
	else: velocity.y = 0
		
	funcs_refs[state].call_func(delta)
	move()

func input():
	direction.x = 0
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_accept"):
		pass
		
func hmove():
	velocity.x = direction.x * speed.x
	
func vmove():
	velocity.y += direction.y * speed.y

func move():
	velocity = move_and_slide(velocity, Vector2.UP)
	
func idle_state(delta):
	pass
	
func running_state(delta): 
	pass
	
func jumping_state(delta):
	pass
	
func falling_state(delta):
	pass
	
func landing_state(delta):
	pass
