extends Sprite2D

var player
var ladder = false


func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if ladder:
			player.velocity.y = -200 * Input.get_axis("MoveDown", "MoveUp")
			player.gravity_value = 0

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		ladder = true
		player.new_state = 8 #switch to climb anim

func _on_area_2d_body_exited(body):
	ladder = false
	player.gravity_value = 980
	player.new_state = 0 #switch to idle
