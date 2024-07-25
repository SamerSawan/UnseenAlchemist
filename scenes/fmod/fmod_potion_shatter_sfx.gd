extends FmodEventEmitter2D

@export var root_node : Node # for signal

func _ready():
	if root_node and root_node.has_method("playsound_potion_shatter"):
		root_node.playsound_potion_shatter.connect(_play_potion_shatter)

func _play_potion_shatter():
	self.play()
