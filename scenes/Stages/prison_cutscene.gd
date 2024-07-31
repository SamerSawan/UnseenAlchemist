extends CanvasLayer

@export var sprite : Sprite2D
var stage_1_scene : String = "res://scenes/Stages/level_1.tscn"

func _ready():
	SceneTreeTimer
	var timer = Timer.new()
	add_child(timer)
	timer.start(.5)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	print("timeout")
	if sprite.frame < sprite.hframes + sprite.vframes:
		sprite.frame += 1
	else:
		get_tree().change_scene_to_file(stage_1_scene)
