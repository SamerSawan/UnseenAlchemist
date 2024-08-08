extends Node
#@onready var musicPlayer = $MusicPlayer

@onready var main_menu_music = $bassser
var cave_id: int = 0
#MAY2024 THE PAUSE MENU BUTTONS ARE BEING MANAGED/CONNECTED FROM HERE AS WELL
var musicToggle: bool = true
var level_changed: bool = false #starts false or it will stay false
var soundToggle: bool = true
#level_changed will be changed to true on level script _ready() (start of every level)
#and changed back to false after connecting the pause
func _ready():
	SignalBus.stop_main_music.connect(main_menu_left)
	SignalBus.start_main_music.connect(main_menu_entered)
	
func main_menu_left():
	main_menu_music.stop()
	
func main_menu_entered():
	if !main_menu_music.playing:
		main_menu_music.play()
