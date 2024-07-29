extends CPUParticles2D

@onready var timer = $Timer

func _ready():
	timer.start()

func _on_area_2d_body_entered(body):
	body.get_parent().is_sleep = true
	SignalBus.is_slept.emit()
	print(body.get_parent().is_sleep)


func _on_area_2d_body_exited(body):
	body.get_parent().is_sleep = false
	SignalBus.is_awake.emit()
	print(body.get_parent().is_sleep)


func _on_timer_timeout():
	queue_free()
