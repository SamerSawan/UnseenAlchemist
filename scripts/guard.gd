extends CharacterBody2D

@onready var Patrol1 = $"PP1"
@onready var Patrol2 = $"PP2"
@onready var WallRaycast = $Raycasts/WallDetect
@onready var HoleRaycast = $Raycasts/HoleDetect

var speed: float = 2500.0
@export var patrol_speed = 200.0
@export var chase_speed = 8000.0

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_spotted: bool = false

var direction
var current_destination
var current_patrol_point: Sprite2D
var last_patrol_point
var player
#"states"
var is_idle: bool = false
var is_chasing: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	patrol_points_setter()
#	$PP1.visible = false uncomment after testing to hide patrol points
#	$PP2.visible = false
	current_patrol_point = Patrol2
	current_destination = current_patrol_point
	direction = position.direction_to(current_destination.position)
	
func _physics_process(delta):
	flip_sprite()
	raycast_business()
	move(delta)
	gravity(delta)
	
	chase()
	move_and_slide()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
		
func idle():#stand around for a few, unless something changes
	$IdleTimer.start()
	velocity.x = 0
	is_idle = true
	
func raycast_business(): #jump over cliffs
	if WallRaycast.is_colliding():
		velocity.y -= 50
	if !HoleRaycast.is_colliding() && $GapJumpCD.is_stopped():
		$GapJumpCD.start()
		velocity.y -= 200
		velocity.x += 200*(round(direction.x))


func chase():
	if is_chasing:
		direction = position.direction_to(player.global_position)
		speed = chase_speed
		
func _on_pp_2_area_body_entered(body):
	if body == self && !is_chasing:
		idle()
		current_destination = Patrol1
		direction = position.direction_to(current_destination.position)


func _on_pp_1_area_body_entered(body):
	if body == self && !is_chasing:
		idle()
		current_destination = Patrol2
		direction = position.direction_to(current_destination.position)

func move(delta):
	if !is_idle && HoleRaycast.is_colliding():
		velocity.x = direction.x*speed*delta

func flip_sprite():
	if !is_idle:
		$Sprite2D.flip_h = (round(direction.x) == -1)
		WallRaycast.target_position.x = 32*(round(direction.x))
		HoleRaycast.position.x = 14*(round(direction.x))
		
func _on_idle_timer_timeout(): #to make him idle at patrol points
	is_idle = false

func spotted_player(body): #on area body entered
	if body == player:
		last_patrol_point = current_destination
		is_chasing = true
		print("HOLY FUCKAMOLEY!!!!")

func lose_aggro(body): #on area body exited
	$LoseAggroTimer.start()

func _on_lose_aggro_timer_timeout(): #stop chasing if LOS broken for too long
	is_chasing = false
	direction = position.direction_to(last_patrol_point.position)
	
func patrol_points_setter(): #this broke for no reason so here's a function
	var PP1globalP = $PP1.global_position
	var PP2globalP = $PP2.global_position
	$PP1.top_level = true #stop the patrol points
	$PP2.top_level = true #from moving with parent
	await get_tree().create_timer(0.1)
	$PP1.global_position = PP1globalP
	$PP2.global_position = PP2globalP #this is genuinely mind boggling
	#becoming top_level ruins positioning, so we're saving them first