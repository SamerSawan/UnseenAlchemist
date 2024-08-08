extends Node2D

@export var is_final_level: bool = false

var Player
func _ready():
	Player = get_tree().get_first_node_in_group("player")
#	respawn()
#	Player.global_position = get_node('CaveDoor' + str(AudioPlayer.cave_id)).global_position
#	SignalBus.deathzone.connect(respawn) #deathzone should just emit player_died
	SignalBus.respawn.connect(respawn)
	SignalBus.start_main_music.emit()

func respawn(): #NOT ACTIVE JULY 29 9:51PM
	Player.global_position = get_tree().get_first_node_in_group("doors").global_position
	Player.respawn_anim()
