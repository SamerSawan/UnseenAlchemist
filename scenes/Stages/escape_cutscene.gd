extends CanvasLayer

@export var sprite : Sprite2D
@export var button : Button

var scene : String = "res://menus/mainmenu.tscn"

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(.5)
	timer.timeout.connect(_on_timer_timeout)
	button.pressed.connect(_on_button_pressed)

func _on_timer_timeout():
	print("timeout")
	if sprite.frame < 49 - 1:
		sprite.frame += 1
	else:
		await get_tree().create_timer(2.2).timeout
		get_tree().change_scene_to_file(scene)

func _on_button_pressed():
	get_tree().change_scene_to_file(scene)
