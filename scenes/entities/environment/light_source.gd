extends Node2D

@onready var ray_to_player = $RayCast2D
var player
var player_position
var player_entered

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta):
#	cast_ray()
	player_detection()
#as is, tags hits if the player is behind a box relative to the light it also 
#it ONLY collides with objects, and points at the player always
#func cast_ray(): #might just signal activate via signalbus? not sure where else this would go though
#	if player_entered == true:
#		player_position = player.global_position
#		var space_state = get_world_2d().direct_space_state
#		var query = PhysicsRayQueryParameters2D.create(global_position, player_position, 16) #have it collide with objects meant to be hidden behind, rather than the player [2^5]
#		query.collide_with_areas = true #layer mask has to be input as a power of 2 for some reason
#		query.collide_with_bodies = false
#		var result = space_state.intersect_ray(query)
#		if result: #hidden behind box
#
#
func _on_detection_area_body_entered(body):
	if body.name == "Player": #should only apply to player
		player_entered = true
		ray_to_player.enabled = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_entered = false
		player.stealth_eye.frame = 0 #or else it wont go back
		player.enter_stealth() #assuming nothing else is going on, should add to player script
		ray_to_player.enabled = false
#func reset():
#	player_entered == false

func player_detection(): #its just so much easier than cast_ray()
	if player_entered == true && !player.is_statue: #points raycast to the player IS BEING CALLED
		ray_to_player.set_target_position(player.global_position - ray_to_player.global_position)
		if ray_to_player.is_colliding(): #collides with box area, not the player
			player.is_stealthed = true
			player.is_hidden = true
			player.stealth_eye.frame = 2 #new hidden icon
			player.enter_stealth()
		else: #no obstuction in LOS (lit up)
			player.is_stealthed = false
			player.is_hidden = false
			player.stealth_eye.frame = 1
			player.exit_stealth()
