extends Control

#This script controls if inventory UI is visible

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var inventory: Inv = preload("res://Inventory/HotBar.tres")

var currentlyActive : int = 0
var isFirstPotion = true

func _ready():
	SignalBus.update_inventory.connect(update_slots)
	SignalBus.potion_crafted.connect(firstPotionCrafted)
	SignalBus.potion_used.connect(update_slots)
	slots[0].texture_button.button_pressed = true
	update_slots()

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func firstPotionCrafted():
	if isFirstPotion:
		SignalBus.equipped_potion = slots[currentlyActive].item
		SignalBus.potion_changed.emit()
	isFirstPotion = false
	

func _process(delta):
	if Input.is_action_just_pressed("ScrollDown"):
		slots[currentlyActive].texture_button.button_pressed = false
		if currentlyActive >= 7:
			currentlyActive = 0
		elif currentlyActive < 0:
			currentlyActive = 7
		elif currentlyActive < 7 and currentlyActive > -1:
			currentlyActive += 1
		slots[currentlyActive].texture_button.button_pressed = true
		SignalBus.equipped_potion = slots[currentlyActive].item
		SignalBus.potion_changed.emit()
	if Input.is_action_just_pressed("ScrollUp"):
		slots[currentlyActive].texture_button.button_pressed = false
		if currentlyActive > 7:
			currentlyActive = 0
		elif currentlyActive < 0:
			currentlyActive = 7
		elif currentlyActive < 8 and currentlyActive > -1:
			currentlyActive -= 1
		slots[currentlyActive].texture_button.button_pressed = true
		print(slots[currentlyActive].item)
		SignalBus.equipped_potion = slots[currentlyActive].item
		SignalBus.potion_changed.emit()
		



