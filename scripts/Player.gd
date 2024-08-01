extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const COMBO_LENGTH = [0.3]

enum STATE {ATTACKING, RECOVERING, DODGING, IDLE, RUNNING}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = STATE.IDLE

var anim_player
var state_timer = 0
var combo_progress = 0

var input_buffer = ""

func _ready():
	anim_player = get_node("AnimationPlayer")

func _physics_process(delta):
	state_timer += delta
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _unhandled_key_input(event):
	var can_override_state = true;
	can_override_state &= state == STATE.ATTACKING && state_timer < COMBO_LENGTH[combo_progress]
	
	if can_override_state:
		if event.is_action_pressed("basic_attack"):
			state = STATE.ATTACKING
		if event.is_action_pressed("dodge"):
			state = STATE.DODGING
