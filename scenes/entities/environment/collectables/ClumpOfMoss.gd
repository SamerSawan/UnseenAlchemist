extends Area2D

var is_inside = false
var item = preload("res://Inventory/inventoryItems/ClumpOfMoss.tres")

func _process(delta):
	if is_inside:
		if Input.is_action_just_pressed("pickup"):
			print("emit signal")
			SignalBus.item = item
			SignalBus.player_pickup.emit()
			queue_free()

func _on_body_entered(body):
	is_inside = true


func _on_body_exited(body):
	is_inside = false
