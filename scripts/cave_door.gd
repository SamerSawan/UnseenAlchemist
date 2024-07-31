extends Node2D

@export_file var next_level
@export var is_spawn_point: bool = false
@export var cave_id: int = 1
var area_active = false
var player

func _input(event):
	if area_active and event.is_action_pressed("MoveUp"):
		on_door_interact()

func _ready():
#	SignalBus.deathzone.connect(respawn)
	player = get_tree().get_first_node_in_group("player")
	respawn()
	
func respawn():
	if is_spawn_point:
#		Player = get_tree().get_first_node_in_group("player")
		player.global_position = global_position
		
func on_door_interact():
	if next_level != null:
		get_tree().change_scene_to_file(next_level)
		
	else:
		pass


func _on_area_2d_body_entered(body):
	if body == player:
		area_active = true


func _on_area_2d_body_exited(body):
	if body == player:
		area_active = false
