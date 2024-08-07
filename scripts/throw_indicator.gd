extends Node2D

#im only leaving the other code in JUST IN CASE i want to add keyboard controls(?) 
var potion_thrower
var player
#most of this is handled in the potion_thrower script
#func _ready():
#	potion_thrower = get_tree().get_first_node_in_group("potion_thrower")
#	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta):#might be easier on the processing
#	rotate_stick()
	look_at(get_global_mouse_position())

#func rotate_stick():
#	rotation_degrees = potion_thrower.indicator_rotator #for cancel situations below
#	if potion_thrower.is_aiming:
#		visible = true
#	else:
#		visible = false
