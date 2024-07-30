extends Node2D

#var direction: Vector2
#var player
#var nearest_light
#@onready var left_hitbox = $Area2D/Left
#@onready var right_hitbox = $Area2D/Right
#
#func _ready():
#	player = get_tree().get_first_node_in_group("player")
##	SignalBus.box_pushing.connect(box_being_moved)
#	await get_tree().create_timer(0.5).timeout
##	print(nearest_light.global_position) #RETURNING NULL???????
##change var so that detection isnt run when unnecessary, might change to when player is close
#func _on_light_detect_area_entered(area): #determines which side the light is on, compared to the box
#	nearest_light = area.get_parent()
#	direction = (nearest_light.global_position - global_position).normalized()
#	print(direction)
#	determine_hitbox_enable()
#
#func _on_light_detect_area_exited(area): #does the same thing to determine which hitbox to turn off
#	nearest_light = area.get_parent()
#	direction = (nearest_light.global_position - global_position).normalized()
#	determine_hitbox_disable()
#
##one for which side should turn on, one for which side should turn off
#func determine_hitbox_enable():
#	if direction.x < 0:
#		right_hitbox.set_deferred("disabled",false)
#	if direction.x > 0:
#		left_hitbox.set_deferred("disabled",false)
#
#func determine_hitbox_disable():
#	if direction.x > 0:
#		right_hitbox.set_deferred("disabled",true)
#	if direction.x < 0:
#		left_hitbox.set_deferred("disabled",true)
#
##these should only work if there's a light source
#func _on_area_2d_body_entered(body):
#	player.enter_stealth()
#
#func _on_area_2d_body_exited(body):
#	player.exit_stealth()
#
#func just_a_connector():
#	SignalBus.box_pushing.connect(box_being_moved)
#
#func box_being_moved(): #update hitboxes while being pushed
#	#crashes if there's more than one crate being pushed
#	direction = (nearest_light.global_position - global_position).normalized()
#	determine_hitbox_enable()
#	determine_hitbox_disable()
