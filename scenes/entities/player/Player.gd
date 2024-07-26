extends CharacterBody2D

@onready var player_sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var throw_indicator = $ThrowIndicator
@onready var throw_indicator_sprite = $ThrowIndicator/Sprite2D
@onready var spotted_eye = $SpottedEye

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#player input
var horizontal_direction: float = 0
var vertical_direction: float = 0
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_actuation = false
var climb_input = false
var dash_input = false
var inputs_active: bool = true

#player movement
@export var SPEED: float = 250.0
@export var JUMP_VELOCITY:float = -400.0
const DRAG = 2000
var last_direction = Vector2.RIGHT
var climbs: int = 2

#mechanics
var can_dash = true
var jump_buffer: bool = false
var coyote_jump: bool = false
var transparency: float
var is_stealthed: bool = true
var watched: bool = false
@export var push_force: float = 80.0
#states
var current_state = null
var prev_state = null
var new_state
enum {IDLE,RUN,WINDUP,THROW,DIE,JUMP,FALL,PUSH}
#nodes
@onready var STATES = $STATES
@onready var RAYCASTS = $Raycasts
@onready var animation_tree = $AnimationTree


func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	
	prev_state = STATES.IDLE 
	current_state = STATES.IDLE
	
	signal_connector()

func _process(_delta):
	animation_handler()
	
func _physics_process(delta):
	if inputs_active:
		player_input()
	change_state(current_state.update(delta))
	
#	$Label.text = str(current_state.get_name())
	box_push()
	move_and_slide()
#	for i in get_slide_collision_count(): #from the interwebs kind of sucks
#		var c = get_slide_collision(i)
#		if c.get_collider() is RigidBody2D:
#			c.get_collider().apply_impulse(-c.get_normal() * push_force)

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func change_animation_state(state):
	new_state = state
	SignalBus.anim_state_change.emit()

func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		prev_state.exit_state()
		current_state.enter_state()

func get_next_to_wall():
	for raycast in RAYCASTS.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x > 0:
				return Vector2.RIGHT
			else:
				return Vector2.LEFT
	return null

func animation_handler():
	if horizontal_direction != 0: #turning
		player_sprite.flip_h = (horizontal_direction == -1)
		throw_indicator.scale.x = -last_direction.x
		throw_indicator.position.x = 11*horizontal_direction
		
	spotted_eye.visible = watched
	
	if new_state == WINDUP:
		inputs_active = false
	else:
		inputs_active = true
	if (new_state != WINDUP) && (new_state != THROW) && (new_state != PUSH): #otherwise it just skips these
		if (velocity.x != 0 && is_on_floor()):
			change_animation_state(RUN)
		if is_on_floor() && velocity.x == 0:
			change_animation_state(IDLE)
		if !is_on_floor():
			if velocity.y < 0:
				change_animation_state(JUMP)
			if velocity.y > 0:
				change_animation_state(FALL)
		
func player_input():
	horizontal_direction = Input.get_axis("MoveLeft", "MoveRight") #returns -1 if first arg is pressed, else 1
	vertical_direction = Input.get_axis("MoveDown", "MoveUp")
	movement_input = Vector2(horizontal_direction, vertical_direction)

	if Input.is_action_pressed("Jump"):
		jump_input_actuation = true
	else: 
		jump_input_actuation = false

	#climb
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false
	
	#dash
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false
	
func respawn_anim(): #CONNECTED TO CAVE DOOR
	animation_tree["parameters/conditions/is_respawning"] = true
	velocity = Vector2.ZERO
	inputs_active = false
	await get_tree().create_timer(0.5).timeout #just to give it time to play
	inputs_active = true
	animation_tree["parameters/conditions/is_respawning"] = false

func jump_buffer_func(): #catches signal from FALL state
	$JumpBuffer.start()
	jump_buffer = true

func _on_jump_buffer_timeout():
	jump_buffer = false

func coyote_jump_func(): #couldnt find anywhere in states, putting it here
	$CoyoteTimer.start()
	coyote_jump = true
		
func _on_coyote_timer_timeout():
	coyote_jump = false

func enter_stealth(): #functions to handle stealth-unique activities
	is_stealthed = true

func exit_stealth():
	is_stealthed = false

func signal_connector():
	SignalBus.jump_buffer.connect(jump_buffer_func)
	SignalBus.coyote_jump.connect(coyote_jump_func)
	SignalBus.stealth_entered.connect(enter_stealth)
	SignalBus.stealth_exited.connect(exit_stealth)


func _on_animation_tree_animation_finished(anim_name): #or it won't switch back to idle
	if new_state == THROW:
		change_animation_state(IDLE)
	#prevent animation from getting stuck

func box_push():
	if $Raycasts/TopRight.is_colliding() && Input.is_action_pressed("MoveRight"):
		$Raycasts/TopRight.get_collider().position.x += 1
		change_animation_state(PUSH)
	elif $Raycasts/TopLeft.is_colliding() && Input.is_action_pressed("MoveLeft"):
		$Raycasts/TopLeft.get_collider().position.x -= 1
		change_animation_state(PUSH)
	else:
		change_animation_state(IDLE)
