extends Area2D

var is_inside = false
var item = preload("res://Inventory/inventoryItems/DeadMouse.tres")

@onready var E = $E_button

func _ready():
	E.visible = false

func _process(_delta):
	if is_inside:
		if Input.is_action_pressed("pickup"):
			SignalBus.item = item
			SignalBus.player_pickup.emit()
			queue_free()

func _on_body_entered(_body):
	is_inside = true
	E.visible = true


func _on_body_exited(_body):
	is_inside = false
	E.visible = false
