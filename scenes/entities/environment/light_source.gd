extends Node2D

var player
var player_position
var player_entered

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta):
	cast_ray()

func cast_ray(): #might just signal activate via signalbus? not sure where else this would go though
	if player_entered == true:
		player_position = player.global_position
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, player_position, 16) #have it collide with objects meant to be hidden behind, rather than the player [2^5]
		query.collide_with_areas = true #layer mask has to be input as a power of 2 for some reason
		query.collide_with_bodies = false
		var result = space_state.intersect_ray(query)
		if result:
			print("Hit at point: ", result.position)

func _on_detection_area_body_entered(body):
	if body.name == "Player": #should only apply to player
		player_entered = true

func _on_detection_area_body_exited(_body):
	player_entered = false
	
func reset():
	player_entered == false

