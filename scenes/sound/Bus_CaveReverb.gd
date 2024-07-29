extends Node
@export var layout : AudioBusLayout

func _ready():
	AudioServer.set_bus_layout(layout)
