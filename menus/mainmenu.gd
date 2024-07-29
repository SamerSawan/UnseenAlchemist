extends Control

@export var startbutton : Node
@export var optionsbutton : Node
@export var quitbutton : Node

func _ready():
	startbutton.pressed.connect(_on_start_button_pressed)
	optionsbutton.pressed.connect(_on_options_button_pressed)
	quitbutton.pressed.connect(_on_quit_button_pressed)
	
	startbutton.grab_focus() # for keyboard
	# if save file exists:
		# show continue & restart
	# else: 
		# show start
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Stages/tutorial.tscn")
	pass


func _on_options_button_pressed():
	var options = load("res://menus/options.tscn").instance()
	if options:
		get_tree().current_scene.add_child(options)
	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass
