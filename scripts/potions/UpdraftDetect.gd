extends Area2D

var updraft_entered: bool = false
var parent_node

var delta = get_physics_process_delta_time()

func _ready():
	parent_node = get_parent()
	print(parent_node)

func _physics_process(delta):
	if updraft_entered:
		if parent_node.name == "Player":
			parent_node.velocity.y -= 1500*delta
			if parent_node.velocity.y < -301:
				parent_node.velocity.y = -300
		elif parent_node.get_class() == "RigidBody2D": #uses diff velocity name
			parent_node.linear_velocity.y -= 1500*delta
			if parent_node.linear_velocity.y < -301:
				parent_node.linear_velocity.y = -300
		else:
			pass
	
#func lift_off(): #having it in a separate func makes it not work??
#	if updraft_entered:
#		parent_node.velocity.y -= 30000*delta
