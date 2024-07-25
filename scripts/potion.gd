extends RigidBody2D

var mouse_position
var x_velocity = 800
var y_velocity = 400

func _ready():
	mouse_position = get_tree().get_first_node_in_group("player").get_local_mouse_position().normalized()
	#get the position of the mouse, relative to the player
	#normalize gives it as a x,y ratio from -1 to 1

func _process(delta):
	aim_potion(delta)

func aim_potion(delta):
	if Input.is_action_pressed("Shoot"):
		x_velocity -= (100 * delta)
		y_velocity += (100 * delta)
		print(Vector2(x_velocity, y_velocity))
	else:
		linear_velocity = Vector2(x_velocity, y_velocity) * mouse_position

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.lose_hp()
		body.hp_label_update()
	queue_free() 
