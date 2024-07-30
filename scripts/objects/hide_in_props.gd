extends Node2D

var player
var player_entered #i would love to save cpu on these, but i know there will be#cases where spotted eye will become invisible while player is in a bush
					#and bug out
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	hide_behind()
	
func hide_behind(): #last condition for light scenario
	if !player.spotted_eye.visible && player_entered && (player.stealth_eye.frame != 1):
		player.stealth_eye.frame = 2

func _on_area_2d_body_entered(body):
	player_entered = true
	
func _on_area_2d_body_exited(body):
	player_entered = false
	player.stealth_eye.frame = 0

