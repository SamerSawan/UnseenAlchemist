extends Node2D

@onready var raycast = $RayCast2D
@export var blade_speed = Vector2(50,-50)

#var level_reset: bool = false #changed to true in level script on player death
var anim_start_time #or else it will crash on reset


#func _ready():
#	level_reset = false

func _process(delta):
	global_position.x += blade_speed.x*delta
	global_position.y -= blade_speed.y*delta
	delete()

func _on_area_2d_body_entered(body):
	if body is Player:
		SignalBus.player_died.emit()

func delete():
	if raycast.is_colliding():
		queue_free()
#	if level_reset:
#		queue_free()
