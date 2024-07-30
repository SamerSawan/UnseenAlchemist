extends CPUParticles2D

@onready var timer = $Timer


func _ready():
	timer.start()

func _on_timer_timeout():
	SignalBus.deactivate_strength.emit()
	queue_free()
