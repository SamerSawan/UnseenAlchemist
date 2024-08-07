class_name Inventory
extends Control

#This script controls if inventory UI is visible

@onready var inventory: Inv = preload("res://Inventory/player_inventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false


func _ready():
	SignalBus.update_inventory.connect(update_slots)
	SignalBus.close_inventory.connect(menu_closed)
	update_slots()
	close()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func _process(_delta):
	if Input.is_action_just_pressed("OpenCrafting"):
		if is_open:
			close()
		else:
			open()

func close():
	visible = false
	is_open = false
	SignalBus.craft_menu_visibility_changed.emit()
	
func open():
	visible = true
	is_open = true
	SignalBus.craft_menu_visibility_changed.emit()
	
func menu_closed():
	close()
