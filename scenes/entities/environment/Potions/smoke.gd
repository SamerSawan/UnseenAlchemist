extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.start()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.is_stealthed = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		body.is_stealthed = false
		print(body.is_stealthed)


func _on_timer_timeout():
	queue_free()
