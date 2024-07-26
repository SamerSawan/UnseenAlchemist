extends Node2D

var direction: Vector2

@onready var left_hitbox = $Area2D/Left
@onready var right_hitbox = $Area2D/Right

#change var so that detection isnt run when unnecessary, might change to when player is close
func _on_light_detect_area_entered(area): #determines which side the light is on, compared to the box
	direction = (area.global_position - global_position)
	determine_hitbox_enable()

func _on_light_detect_area_exited(_area): #does the same thing to determine which hitbox to turn off
	determine_hitbox_disable()
	
#one for which side should turn on, one for which side should turn off
func determine_hitbox_enable():
	if global_position.x > direction.x:
		right_hitbox.set_deferred("disabled",false)
	if global_position.x < direction.x:
		left_hitbox.set_deferred("disabled",false)

func determine_hitbox_disable():
	if global_position.x > direction.x:
		right_hitbox.set_deferred("disabled",true)
	if global_position.x < direction.x:
		left_hitbox.set_deferred("disabled",true)
