extends Node2D

var player
var player_position

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):
	player_position = player.global_position #no clue if this will work (with ready)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player_position,
		1, [self])
	var result = space_state.intersect_ray(query)
#	if result:
#		print("Hit at point: ", result.position)
