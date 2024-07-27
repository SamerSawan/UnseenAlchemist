extends StaticBody2D

@export var Item: InventoryItem

func _ready():
	print(Item.name)
	print(Item.texture)
