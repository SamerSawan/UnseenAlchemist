extends Control

@export var continuebutton : Node
@export var newbutton : Node
@export var optionsbutton : Node
@export var quitbutton : Node

func _ready():
#	continuebutton.pressed.connect(_on_continue_button_pressed)
	newbutton.pressed.connect(_on_new_button_pressed)
#	optionsbutton.pressed.connect(_on_options_button_pressed)
	quitbutton.pressed.connect(_on_quit_button_pressed)
	
	newbutton.grab_focus() # for keyboard or controller
	
#	if !FileAccess.file_exists(SaveHandler.SAVE_GAME_PATH):
#		continuebutton.visible = false

#func _on_continue_button_pressed():
#	SaveHandler.call("load_game")

func _on_new_button_pressed():
	SaveHandler.call("new_game")
	pass


#func _on_options_button_pressed():
#	if ResourceLoader.exists("res://menus/options.tscn"):
#		var options = load("res://menus/options.tscn").instance()
#		if options:
#			get_tree().current_scene.add_child(options)
#	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass


func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://scenes/other/level_selector.tscn")
