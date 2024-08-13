extends Node2D

@onready var detection_area = $DetectionArea
var body_entered: bool = false
#if trap: blow upwards (saws)
#then, the rest of the stuff like get_collider() 
#well actually in my head i had it so a box under a player would lift
#the player independently of the wind, but it might be extra work for so little effort
var delta = get_physics_process_delta_time() #announce delta for other functions
#hopefully thats enough, and it doesnt need to be updated or something

func _on_expire_timer_timeout():
	$CPUParticles2D.emitting = false
	await get_tree().create_timer(1.0).timeout #let the particles timeout naturally
	queue_free()

func _on_detection_area_area_entered(area):
	area.updraft_entered = true


func _on_detection_area_area_exited(area):
	area.updraft_entered = false
