extends CanvasLayer

@export var sprite : Sprite2D
@export var button : Button
@export var black_color : ColorRect
var stage_1_scene : String = "res://scenes/Stages/level_1.tscn"

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.start(.5)
	timer.timeout.connect(_on_timer_timeout)
	button.pressed.connect(_on_button_pressed)

func _on_timer_timeout():
	print("timeout")
	if sprite.frame < sprite.hframes + sprite.vframes:
		sprite.frame += 1
	else:
		get_tree().change_scene_to_file(stage_1_scene)

func _on_button_pressed():
	get_tree().change_scene_to_file(stage_1_scene)
