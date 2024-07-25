extends FmodEventEmitter2D

@export var root_node : Node # for signal

func _ready():
	if root_node and root_node.has_method("playsound_player_walk"):
		root_node.playsound_player_walk.connect(_play_player_walk) # signal connector

func _play_player_walk():
	if root_node and root_node.current_state == root_node.STATES.MOVE: # to ensure the sound doesnt play while jumping
		play()
