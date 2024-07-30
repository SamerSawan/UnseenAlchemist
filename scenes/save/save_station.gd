extends Node2D

#@export var area_2d : Area2D

var is_inside = false

#func _ready():
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	area_2d.area_exited.connect(_on_area_2d_area_exited)

func _process(delta):
	if is_inside and Input.is_action_just_pressed("pickup"):
		SaveHandler.call("save_game")
		print("game save called")

func _on_area_2d_area_entered(area):
	is_inside = true
	print("is_inside")


func _on_area_2d_area_exited(area):
	is_inside = false
	print("!is_inside")
