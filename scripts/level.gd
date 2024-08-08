extends Node2D

func _ready():
	SignalBus.inventory_reset.emit()
	SignalBus.potion_changed.emit() #prevents using the last equipped potions in new level
	SignalBus.stop_main_music.emit()
	SignalBus.play_level_music.emit()
