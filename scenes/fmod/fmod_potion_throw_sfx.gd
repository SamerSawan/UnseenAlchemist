extends FmodEventEmitter2D

@export var root_node : Node # for signal

func _ready():
	if root_node and root_node.has_method("playsound_player_throw"):
		root_node.playsound_player_throw.connect(_play_player_throw)

func _play_player_throw():
	self.play()
