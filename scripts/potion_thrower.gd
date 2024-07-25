extends Node2D

@onready var potion_container = $potion_container
var potion = preload("res://scenes/entities/player/potion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shoot()


func shoot():
	if Input.is_action_just_pressed("Shoot"):
		var potion_instance = potion.instantiate()
		potion_container.add_child(potion_instance)
		potion_instance.global_position = $Marker2D.global_position
