extends Node2D

var potion_thrower
#most of this is handled in the potion_thrower script
func _ready():
	potion_thrower = get_tree().get_first_node_in_group("potion_thrower")
	
func _physics_process(delta):#might be easier on the processing
	rotate_stick()

func rotate_stick():
	rotation_degrees = potion_thrower.indicator_rotator
	if rotation_degrees == 20: 
		visible = false
	else:
		visible = true
