extends CanvasLayer

#This script controls if inventory UI is visible

var is_open = false


func _ready():
	close()

func _process(_delta):
	if Input.is_action_just_pressed("OpenHelp"):
		if is_open:
			close()
		else:
			open()

func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true
