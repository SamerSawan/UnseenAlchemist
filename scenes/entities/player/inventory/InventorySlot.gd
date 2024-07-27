extends Panel


@onready var item_display = $CenterContainer/Panel/itemDisplay


func update(item: InventoryItem):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
