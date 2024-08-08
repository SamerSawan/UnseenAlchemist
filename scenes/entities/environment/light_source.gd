extends Node2D

@onready var ray_to_player = $RayCast2D
var player
var player_position
var player_entered: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	player_detection()

func _on_detection_area_body_entered(body):
	if body.name == "Player": #should only apply to player
		ray_to_player.enabled = true
		player_entered = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_entered = false
		player.stealth_eye.frame = 0 #or else it wont go back
		player.enter_stealth() #assuming nothing else is going on, should add to player script
		ray_to_player.enabled = false

#func reset():
#	player_entered == false

func player_detection(): #its just so much easier than cast_ray()
	if player_entered == true && !player.is_statue && !player.is_invisible: #points raycast to the player IS BEING CALLED
		ray_to_player.set_target_position(player.global_position - ray_to_player.global_position)
		if ray_to_player.is_colliding() && ray_to_player.get_collision_mask_value(5): #collides with areas only?? this works for the box
			player.is_stealthed = true #but not for the tileset
			player.is_hidden = true
			player.stealth_eye.frame = 2 #new hidden icon
			player.enter_stealth()
		else: #no obstuction in LOS (lit up) AUG8 BUG: LIGHTS UP PLAYERS THROUGH TILEMAP
			player.is_stealthed = false
			player.is_hidden = false
			player.stealth_eye.frame = 1
			player.exit_stealth()

