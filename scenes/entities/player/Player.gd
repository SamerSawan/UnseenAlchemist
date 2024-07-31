class_name Player
extends CharacterBody2D

@onready var player_sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var throw_indicator = $ThrowIndicator
@onready var throw_indicator_sprite = $ThrowIndicator/Sprite2D
@onready var spotted_eye = $SpottedEye/Spotted
@onready var stealth_eye = $SpottedEye/Stealthed
@onready var spotted_sound = $Sound_PlayerWatched
@onready var watcher_particles = $WatcherParticles

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#Inventory Related
@export var inventory: Inv

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
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY:float = -400.0
const DRAG = 2000
var last_direction = Vector2.RIGHT
var climbs: int = 2

#mechanics
var can_dash = true
var jump_buffer: bool = false
var coyote_jump: bool = false
var transparency: float
var is_visible: bool = false
var is_stealthed: bool = true
var watched: bool = false
var being_chased: bool = false
var dying: bool = false
var is_hidden: bool = false #for hiding in props or behind boxes
var is_invisible: bool = false
#@export var push_force: float = 80.0
#states
var current_state = null
var prev_state = null
var new_state
enum {IDLE,RUN,WINDUP,THROW,DIE,JUMP,FALL,PUSH,CLIMB,DRINK,DASH}
#nodes
@onready var STATES = $STATES
@onready var RAYCASTS = $Raycasts
@onready var animation_tree = $AnimationTree

#potion_effects
var is_strong = false
var dash_enabled = false
var is_statue = false
@onready var strength = $Strength
@onready var dash = $Dash
@onready var invis = $Invis
@onready var invis_timer = $Invis/invis_timer


func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	
	prev_state = STATES.IDLE 
	current_state = STATES.IDLE
	
	var watched_timer : Timer = Timer.new()
	self.add_child(watched_timer)
	watched_timer.set_one_shot(false)
	watched_timer.start(0.2)
	watched_timer.timeout.connect(_on_watched_timer_timeout)
	
	signal_connector()

func _process(_delta):
	animation_handler()
	
func _physics_process(delta):
	print(is_hidden)
	if inputs_active && !dying and !is_statue:
		player_input()
		change_state(current_state.update(delta))
	
#	$Label.text = str(current_state.get_name())
	box_push()
	
	if !is_statue:
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
		$StoneSprite.flip_h = (horizontal_direction == -1)
		throw_indicator.scale.x = -last_direction.x
		throw_indicator.position.x = 11*horizontal_direction
		
	spotted_eye.visible = watched
	stealth_eye.visible = !spotted_eye.visible #should be one or the other
	

	if new_state == WINDUP:
		inputs_active = false
	else:
		inputs_active = true #very not good 
	if (new_state != WINDUP) && (new_state != THROW) && (new_state != PUSH) && (new_state != DIE)&&(new_state != DRINK)&&(new_state != CLIMB): #otherwise it just skips these
		if (velocity.x != 0 && is_on_floor()):
			change_animation_state(RUN)
		if is_on_floor() && velocity.x == 0:
			change_animation_state(IDLE)
		if !is_on_floor():
			if velocity.y < 0:
				change_animation_state(JUMP)
			if velocity.y > 0:
				change_animation_state(FALL)
	running_particles()

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
	if Input.is_action_just_pressed("Dash") and dash_enabled:
		dash_input = true
	else: 
		dash_input = false
	
func respawn_anim(): #needs to be updated
	velocity.x = 0
	if velocity.y < 0:
		velocity.y = 0
	inputs_active = false
	dying = true #used to stop indicator from showing up on death
	change_animation_state(DIE)
	z_index = 10

func jump_buffer_func(): #catches signal from FALL state
	$JumpBuffer.start()
	jump_buffer = true

func _on_jump_buffer_timeout():
	jump_buffer = false

func coyote_jump_func(): #couldnt find anywhere in states, putting it here
	$CoyoteTimer.start()
	coyote_jump = true

func player_pickup_func():
	print(SignalBus.item.name)
	inventory.insert(SignalBus.item)

func _on_coyote_timer_timeout():
	coyote_jump = false

func enter_stealth(): #functions to handle stealth-unique activities
	is_stealthed = true

func exit_stealth():
	is_stealthed = false

func activate_strength():
	is_strong = true
	SPEED = 300
	JUMP_VELOCITY = -440
	strength.emitting = true
	
	$Strength/strength_timer.start()

func activate_dash():
	dash_enabled = true
	dash.emitting = true
	$Dash/dash_timer.start()

func activate_invis():
	$Sprite2D.self_modulate.a = 0.0
	is_invisible = true
	invis.emitting = true
	$Invis/invis_timer.start()

func activate_statue():
	is_statue = true
	is_hidden = true
	player_sprite.visible = false
	$StoneSprite.visible = true
	$statue_timer.start()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_statue_timer_timeout():
	is_statue = false
	is_hidden = false
	player_sprite.visible = true
	$StoneSprite.visible = false
	$CollisionShape2D.set_deferred("disabled", false)
	
func signal_connector():
	SignalBus.jump_buffer.connect(jump_buffer_func)
	SignalBus.coyote_jump.connect(coyote_jump_func)
	SignalBus.stealth_entered.connect(enter_stealth)
	SignalBus.stealth_exited.connect(exit_stealth)
	SignalBus.player_pickup.connect(player_pickup_func)
	SignalBus.activate_strength.connect(activate_strength)
	SignalBus.activate_dash.connect(activate_dash)
	SignalBus.activate_invis.connect(activate_invis)
	SignalBus.activate_statue.connect(activate_statue)
	SignalBus.player_died.connect(respawn_anim)

func _on_animation_tree_animation_finished(anim_name): #or it won't switch back to idle
	if new_state == THROW: #i literally have no idea how this is working
		change_animation_state(IDLE)
	#prevent animation from getting stuck
	if anim_name == "death": #reset level on death
		get_tree().reload_current_scene()

func box_push():
	if $Raycasts/TopRight.is_colliding() && Input.is_action_pressed("MoveRight"):
		$Raycasts/TopRight.get_collider().position.x += 1
		change_animation_state(PUSH)

	elif $Raycasts/TopLeft.is_colliding() && Input.is_action_pressed("MoveLeft"):
		$Raycasts/TopLeft.get_collider().position.x -= 1
		change_animation_state(PUSH)

	elif new_state != WINDUP:
		change_animation_state(IDLE)


func _on_watched_timer_timeout(): # to trigger music
	if spotted_sound:
		if watched:
			spotted_sound.fade_in()
		else:
			spotted_sound.fade_out()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"current_scene" : get_tree().get_current_scene().scene_file_path,
		"inventory" : serialize_inventory(inventory.items),
	}
	return save_dict

func serialize_inventory(slots: Array) -> Array:
	var serialized_slots = []
	for slot in slots:
		var serialized_slot = {
			"item_name": slot.item_name,
			"item_texture_path": slot.item.texture.get_path(),
			"quantity": slot.quantity
		}
		serialized_slots.append(serialized_slot)
	return serialized_slots

func _on_strength_timer_timeout():
	is_strong = false
	SPEED = 200
	JUMP_VELOCITY = -350
	strength.emitting = false

func _on_dash_timer_timeout():
	dash_enabled = false
	dash.emitting = false

func _on_invis_timer_timeout():
	$Sprite2D.self_modulate.a = 1
	is_invisible = false
	invis.emitting = false

func running_particles(): #might remove if its costing too much cpu power
	if is_on_floor() && velocity.x != 0:
		$RunningParticles.emitting = true
	else:
		$RunningParticles.emitting = false


