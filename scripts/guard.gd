extends CharacterBody2D

@onready var Patrol1 = $PatrolPoints/PP1
@onready var Patrol2 = $PatrolPoints/PP2
@onready var WallRaycast = $Raycasts/WallDetect
@onready var HoleRaycast = $Raycasts/HoleDetect
@onready var ray_to_player = $Raycasts/ToPlayerRaycast
@onready var gapRaycast = $Raycasts/GapCalculator
@onready var guard_sprite = $AnimatedSprite2D

var speed: float = 2500.0

@export var patrol_speed = 2500.0
@export var chase_speed = 8000.0 #player shouldnt be able to outrun normally
@export var jump_strength_x = 2.0
@export var jump_strength_y = 300.0

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_spotted: bool = false
var direction
var current_destination: Vector2
var current_patrol_point: Vector2
var last_patrol_point: Vector2
var player
var to_cliff: float
var distance_to_player
#"states"
var is_idle: bool = false
var is_chasing: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
#	patrol_points_setter()
#	$PP1.visible = false uncomment after testing to hide patrol points
#	$PP2.visible = false
	current_patrol_point = Patrol2.position
	current_destination = current_patrol_point
	direction = position.direction_to(current_destination)
	
func _physics_process(delta):
	flip_sprite()
	raycast_business()
	move(delta)
	gravity(delta)
	animation_handler()
	chase()
	
	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
		
func idle():#stand around for a few, unless something changes
	$IdleTimer.start()
	velocity.x = 0
	is_idle = true
	guard_sprite.play("idle")
	
func raycast_business(): #jump over cliffs
	gap_distance()
	if WallRaycast.is_colliding():
		velocity.y -= 50
	if !HoleRaycast.is_colliding() && $GapJumpCD.is_stopped() && gapRaycast.is_colliding(): #hops
#		gapRaycast.enabled = true
		$GapJumpCD.start() #to stop forces from constantly applying
		velocity.y -= jump_strength_y
		velocity.x += jump_strength_x*(round(direction.x)) * to_cliff
#		gapRaycast.enabled = false
#	elif !HoleRaycast.is_colliding(): trying to get him to turn around if there's no 
#		idle()

func animation_handler():
	if !is_chasing && !is_idle:
		guard_sprite.play("walk")
	
func chase():
	if is_chasing:
		direction = position.direction_to(player.global_position)
		speed = chase_speed
		player.watched = true
		kill_mode()

func _on_pp_2_area_body_entered(body):
	if body == self && !is_chasing:
		idle()
		current_destination = Patrol1.position
		direction = position.direction_to(current_destination)


func _on_pp_1_area_body_entered(body):
	if body == self && !is_chasing:
		idle()
		current_destination = Patrol2.position
		direction = position.direction_to(current_destination)

func move(delta):
	if !is_idle && HoleRaycast.is_colliding():
		velocity.x = direction.x*speed*delta

func flip_sprite():
	if !is_idle:
		guard_sprite.flip_h = (round(direction.x) == -1)
		WallRaycast.target_position.x = 32*(round(direction.x))
		HoleRaycast.position.x = 14*(round(direction.x))
		gapRaycast.target_position.x = 160*(round(direction.x))
		gapRaycast.position.x = 24*(round(direction.x))
		
func _on_idle_timer_timeout(): #to make him idle at patrol points
	is_idle = false

func spotted_player(body): #on area body entered
	if body == player && !player.is_stealthed: #check stealth
		is_idle = false #break idle on detection
		guard_sprite.play("chase")
		$LoseAggroTimer.stop() #this WONT trigger the timeout effect, but will reset timer
		last_patrol_point = current_destination
		is_chasing = true

func lose_aggro(body): #on area body exited
	$LoseAggroTimer.start()

func _on_lose_aggro_timer_timeout(): #stop chasing if LOS broken for too long
	guard_sprite.play("walk")
	is_chasing = false
	direction = position.direction_to(last_patrol_point)
	speed = patrol_speed
	player.watched = false
	
func gap_distance(): #increases x jump speed according to gap
	gapRaycast.enabled = !HoleRaycast.is_colliding()
	if gapRaycast.is_colliding():
		var collision_point = gapRaycast.get_collision_point()
		to_cliff = position.distance_to(collision_point)
		
#func below solved but keeping just in case
#func patrol_points_setter(): #this broke for no reason so here's a function
#	var PP1globalP = $PP1.global_position
#	var PP2globalP = $PP2.global_position
#	$PP1.top_level = true #stop the patrol points
#	$PP2.top_level = true #from moving with parent
#	await get_tree().create_timer(0.1)
#	$PP1.global_position = PP1globalP
#	$PP2.global_position = PP2globalP #this is genuinely mind boggling
#	#becoming top_level ruins positioning, so we're saving them first

func kill_mode():
	distance_to_player = (position - player.global_position)
	if abs(distance_to_player) < Vector2(40,30):
		guard_sprite.play("attack")
		SignalBus.player_died.emit()
		velocity.x = 0
		
func _on_stealth_detect_area_body_entered(body):
	if body == player && player.is_stealthed: #check stealth
		is_idle = false #break idle on detection
		guard_sprite.play("chase")
		$LoseAggroTimer.stop() #this WONT trigger the timeout effect, but will reset timer
		last_patrol_point = current_destination
		is_chasing = true

