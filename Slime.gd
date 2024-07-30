extends CPUParticles2D

@onready var timer = $Timer
var pBody


func _ready():
	timer.start()

func _on_area_2d_body_entered(body):
	pBody = body
	if body.name == "Guard":
		body.is_slowed = true
		print(body.is_slowed)
	else:
		pass
	SignalBus.is_slowed.emit()

func _on_timer_timeout():
	queue_free()
