extends Node2D

var saw_scene = preload("res://scenes/entities/environment/traps/saw_shot.tscn") #access specific saw to be shot

@onready var shot_timer = $ShotTimer
@onready var blade_container = $BladeContainer

@export var first_shot_cooldown: float = 0
@export var shot_cooldown: float = 2
@export var blade_speed_x: float = 70
@export var blade_speed_y: float = 70 #blade speeds
@export var shoot_on_start: bool = false
var direction_x
var direction_y

func _ready():
	shot_timer.wait_time = shot_cooldown #adjustable shot cooldown
	rotation_id() #get the rotation of the shooter
	if shoot_on_start:
		shoot()
	await get_tree().create_timer(first_shot_cooldown).timeout
	shot_timer.start(shot_cooldown) #or else the first timer countdown will start at 2 seconds
	
#	var level = get_tree().get_first_node_in_group("levels") #detect when player dies
#	level.player_reset.connect(reset)
	
func shoot():
	var saw_instance = saw_scene.instantiate() 
	blade_container.call_deferred("add_child", saw_instance) #create instance, add to node tree as child
	saw_instance.global_position = global_position #set saw position to shooter position
	saw_instance.blade_speed = Vector2(blade_speed_x*direction_x, blade_speed_y*direction_y) #use positive y, corrected for up/down
	saw_instance.rotation = rotation #rotate so that the destroying raycast is facing the right way
	saw_instance.scale = scale*0.6 #scale up the saws with the shooters
	
func _on_shot_timer_timeout():
	shoot()
#
#func reset(): #for stages where i want blades to shoot off rip
#	if shoot_on_start:
#		shot_timer.start() #restart the shot timer so it doesnt double shoot
#		shoot()

func rotation_id(): #shoot the saw blades out correctly at 4 different angles
	#i had to round the numbers down or it would be inconsistent
	if int(fmod(rotation, deg_to_rad(360))) == 0: #x = 0, Y = 1
		direction_x = 0
		direction_y = 1
	if int(fmod(rotation, deg_to_rad(360))) == 1: #90 deg X = 1, Y=0
		direction_x = 1
		direction_y = 0
	if int(fmod(rotation, deg_to_rad(360))) == 3: #180 deg X = 0, Y = -1
		direction_x = 0
		direction_y = -1
	if int(fmod(rotation, deg_to_rad(360))) == 4: #270 deg X = -1, Y = 0
		direction_x = -1
		direction_y = 0
