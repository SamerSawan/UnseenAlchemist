extends Node
#@onready var musicPlayer = $MusicPlayer

var cave_id: int = 0
#MAY2024 THE PAUSE MENU BUTTONS ARE BEING MANAGED/CONNECTED FROM HERE AS WELL
var musicToggle: bool = true
var level_changed: bool = false #starts false or it will stay false
var soundToggle: bool = true
#level_changed will be changed to true on level script _ready() (start of every level)
#and changed back to false after connecting the pause

#func _process(_delta):
#	if level_changed: #will activate at level start
#		connect_pause_menu() 
#
##
#func connect_pause_menu(): #this function connect's the pause button for an individual level
#		var pauseMenu = get_tree().get_nodes_in_group("pauseMenu") #fetch level's pauseMenu node
#
#		for pause in pauseMenu:
#			pause.musicToggler.connect(_on_music_button_pressed) #connect the music button toggle via signal
#			pause.soundToggler.connect(_on_sound_button_pressed) #connect sound
#
#		level_changed = false #returns to false so it doesnt spam unnecessarily

