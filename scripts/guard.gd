extends CharacterBody2D

@onready var Patrol1 = $"PP1"
@onready var Patrol2 = $"PP2"
@onready var WallRaycast = $Raycasts/WallDetect
@onready var HoleRaycast = $Raycasts/HoleDetect

@export var patrol_speed = 200.0
@export var chase_speed = 300.0

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_spotted: bool = false

var direction
var current_destination
var current_patrol_point: Sprite2D
var player
#"states"
var is_idle: bool = false
var is_chasing: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$PP1.top_level = true #stop the patrol points
	$PP2.top_level = true #from moving with parent
	current_patrol_point = Patrol2
	current_destination = current_patrol_point
	direction = position.direction_to(current_destination.position)
	
func _physics_process(delta):
	flip_sprite()
	raycast_business()
	move(delta)
	gravity(delta)
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
		velocity.x += 200

func spotted_player():
	player_spotted = true
	

func _on_pp_2_area_body_entered(body):
	if body == self:
		idle()
		if !is_chasing:
			current_destination = Patrol1
			direction = position.direction_to(current_destination.position)


func _on_pp_1_area_body_entered(body):
	if body == self:
		idle()
		if !is_chasing:
			current_destination = Patrol2
			direction = position.direction_to(current_destination.position)

func move(delta):
	if !is_idle && HoleRaycast.is_colliding():
		velocity.x = direction.x*patrol_speed*delta

func flip_sprite():
	if !is_idle:
		$Sprite2D.flip_h = (round(direction.x) == -1)
		WallRaycast.target_position.x = 32*(round(direction.x))
func _on_idle_timer_timeout():
	is_idle = false
