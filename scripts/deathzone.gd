extends Area2D


func _on_body_entered(body):
	SignalBus.player_died.emit()

