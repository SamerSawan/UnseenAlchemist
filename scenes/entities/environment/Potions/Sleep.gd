extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.start()

func _on_area_2d_body_entered(body):
	if body.name == "Guard":
		body.is_sleep = true
		print(body.is_sleep)
	else:
		body.get_parent().is_sleep = true
		print(body.get_parent().is_sleep)
	SignalBus.is_slept.emit()


func _on_area_2d_body_exited(body):
	if body.name == "Guard":
		body.is_sleep = false
		print(body.is_sleep)
	else:
		body.get_parent().is_sleep = false
		print(body.get_parent().is_sleep)
	SignalBus.is_awake.emit()
	


func _on_timer_timeout():
	queue_free()
