extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.start()
	
#lowkey i think this will work without any of this
#it just needs to break LOS

func _on_area_2d_body_entered(body): 
#	if body.name == "Player":
#		body.is_stealthed = true
	pass

func _on_area_2d_body_exited(body): #
	pass
#	if body.name == "Player":
#		body.is_stealthed = false
#		print(body.is_stealthed)


func _on_timer_timeout():
	queue_free()
