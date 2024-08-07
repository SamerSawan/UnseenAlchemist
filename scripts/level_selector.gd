extends Control

@onready var input_text = $LineEdit
@onready var up_to_text = $UpTo
#DirAccess tree function accesses files and puts them into a list
@onready var levelList = DirAccess.get_files_at("res://scenes/Levels/")


func _ready():
	up_to_text.text = ("(Up To: " + str(levelList.size()) + ")")

func select_level(input):
	get_tree().change_scene_to_file("res://scenes/Levels/" + str(levelList[input])) 
	#when run, changes the scene to the selected one
	#it converts the array element (name of level) into a string to load it

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menus/mainmenu.tscn")


func _on_confirm_stage_pressed():
	if (int(input_text.text) > 0 && int(input_text.text) <= levelList.size()): 
		var player_input = int(input_text.text) - 1 #text returns as a string so we need to convert to int
		#because we cant call an array index off a string
		select_level(player_input)
	else:
		pass

