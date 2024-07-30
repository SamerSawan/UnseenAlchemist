extends Node2D

var potion_thrower
var player
#most of this is handled in the potion_thrower script
func _ready():
	potion_thrower = get_tree().get_first_node_in_group("potion_thrower")
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):#might be easier on the processing
	rotate_stick()

func rotate_stick():
	rotation_degrees = potion_thrower.indicator_rotator #for cancel situations below
	if (Input.is_action_just_released("Shoot") || player.inputs_active == true) && player.is_on_floor(): 
		visible = false
	if Input.is_action_just_pressed("Shoot") || (player.inputs_active == false && player.dying == false):
		visible = true
