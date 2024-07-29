extends Control

#This script controls if inventory UI is visible

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var inventory: Inv = preload("res://Inventory/HotBar.tres")

var currentlyActive : int = 0

func _ready():
	SignalBus.update_inventory.connect(update_slots)
	slots[0].texture_button.button_pressed = true
	update_slots()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func _process(delta):
	if Input.is_action_just_pressed("ScrollDown"):
		slots[currentlyActive].texture_button.button_pressed = false
		if currentlyActive >= 7:
			currentlyActive = 0
		elif currentlyActive < 0:
			currentlyActive = 8
		elif currentlyActive < 8 and currentlyActive > -1:
			currentlyActive += 1
		slots[currentlyActive].texture_button.button_pressed = true
		SignalBus.equipped_item = slots[currentlyActive].item
	if Input.is_action_just_pressed("ScrollUp"):
		slots[currentlyActive].texture_button.button_pressed = false
		if currentlyActive > 7:
			currentlyActive = 0
		elif currentlyActive < 0:
			currentlyActive = 7
		elif currentlyActive < 8 and currentlyActive > -1:
			currentlyActive -= 1
		slots[currentlyActive].texture_button.button_pressed = true
		SignalBus.equipped_item = slots[currentlyActive].item



