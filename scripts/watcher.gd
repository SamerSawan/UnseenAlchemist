extends Node2D

var player
var player_entered #toggle raycast tracking

@onready var ray_to_player = $RayCast2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta):
	player_detection()

			
func _on_detection_area_body_entered(body):
	if body.name == "Player": #should only apply to player
		ray_to_player.set_deferred("enabled",true)
		player_entered = true

func _on_detection_area_body_exited(_body):
	ray_to_player.set_deferred("enabled",false)
	player_entered = false
	player.watched = false
	
func player_detection():
	if player_entered == true: #points raycast to the player
		ray_to_player.set_target_position(player.global_position - ray_to_player.global_position)
		if ray_to_player.is_colliding() && ray_to_player.get_collider() == player: #checks if first object hit is player
			player.watched = true
			print("yep... thats him") #ideally, this part will warn enemies
			#or do whatever the watcher does when it detects the player
		else:
			player.watched = false
