extends CanvasLayer

@export var sprite : Sprite2D
@export var button : Button

var scene : String = "res://scenes/Levels/level_1.tscn"

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(.41)
	timer.timeout.connect(_on_timer_timeout)
	button.pressed.connect(_on_button_pressed)

func _on_timer_timeout():
	if sprite.frame < 23:
		sprite.frame += 1
	else:
		#await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file(scene)

func _on_button_pressed():
	get_tree().change_scene_to_file(scene)
