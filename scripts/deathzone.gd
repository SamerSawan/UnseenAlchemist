extends Area2D


func _on_body_entered(_body):
	SignalBus.emit_signal("player_died") #handled in cave_door since thats the respawn point
