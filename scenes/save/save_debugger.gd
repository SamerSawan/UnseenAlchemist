extends CanvasLayer

func _on_save_pressed():
	SaveHandler.call("save_game")

func _on_load_pressed():
	SaveHandler.call("load_game")
