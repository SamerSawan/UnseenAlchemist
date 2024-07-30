extends CanvasLayer
class_name Cave_Background

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta):	
	offset = player.position
