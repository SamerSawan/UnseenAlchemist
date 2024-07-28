extends Resource

class_name Inv

@export var items: Array[InventorySlot]



func insert(item: InventoryItem):
	#itemslots checks if item is alr in inventory, if so increase amount
	var itemslots = items.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].quantity += 1
	#else adds item to empty slot
	else:
		var emptyslots = items.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].quantity = 1
	SignalBus.update_inventory.emit()
