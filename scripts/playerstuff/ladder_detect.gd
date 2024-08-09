extends Area2D

var player
var ladder = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _input(event):
	if event.is_action_pressed("Jump") && ladder && $JumpCooldown.is_stopped(): #jump while on ladders
		$JumpCooldown.start()
		$JumpTimer.start()
		player.gravity_value = 980
		if !player.is_on_floor(): #looks stupid, thats just how it is
			player.velocity.y -= 350 #runs once for EVERY LADDER

func _physics_process(delta):
	if ladder && $JumpTimer.is_stopped() && !player.dying:
		player.velocity.y = -200 * Input.get_axis("MoveDown", "MoveUp")
		if Input.get_axis("MoveDown", "MoveUp") != 0:
			player.gravity_value = 0
#		else:
#			player.gravity_value = 980

func _on_body_entered(body): #should only collide with ladders, so i'll assume i dont need to specify
	ladder = true
	player.change_animation_state(8) #switch to climb anim #cant get it to work
	


func _on_body_exited(body):
	ladder = false
	player.gravity_value = 980
	player.change_animation_state(0)
