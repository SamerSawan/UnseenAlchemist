extends RigidBody2D

var mouse_position

func _ready():
	var potion_parent = get_tree().get_first_node_in_group("potion_thrower")
#	mouse_position = get_tree().get_first_node_in_group("player").get_local_mouse_position().normalized()
	linear_velocity = potion_parent.potion_velocity
	#get the position of the mouse, relative to the player (* mouse_position)
	#normalize gives it as a x,y ratio from -1 to 1


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.lose_hp()
		body.hp_label_update()
	
	var sound_queue = get_node("SoundQueue_PotionShatter")
	sound_queue.reparent(get_node("/root"), true)
	sound_queue.play_sound()
	
	queue_free() 
	
