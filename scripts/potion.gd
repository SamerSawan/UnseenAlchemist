extends RigidBody2D


func _ready():
	var potion_parent = get_tree().get_first_node_in_group("potion_thrower")
	linear_velocity = potion_parent.potion_velocity


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.lose_hp()
		body.hp_label_update()
	
	var sound_queue = get_node("SoundQueue_PotionShatter")
	sound_queue.reparent(get_node("/root"), true)
	sound_queue.play_sound()
	
	queue_free() 
	
