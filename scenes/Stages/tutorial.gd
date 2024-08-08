extends Node2D

func _ready():
	SignalBus.start_main_music.emit()
