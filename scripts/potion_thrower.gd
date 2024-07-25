extends Node2D

@onready var potion_container = $potion_container
var potion = preload("res://scenes/entities/player/potion.tscn")
@export var potion_velocity: Vector2 = Vector2(400,-200)


func _process(delta):
	aim_potion(delta)

func aim_potion(delta): #hold to wind up throw 
	if Input.is_action_pressed("Shoot") && potion_velocity.x > 0 && potion_velocity.y > -500:
		potion_velocity.x -= (100 * delta)
		potion_velocity.y -= (100 * delta)

	else:
		shoot()


func shoot():
	if Input.is_action_just_released("Shoot"): #fire on release
		var player = get_tree().get_first_node_in_group("player")
		potion_velocity.x *= player.last_direction.x
		SignalBus.shoot_anim.emit() #signal to advance animationtree state
		var potion_instance = potion.instantiate()
		potion_container.add_child(potion_instance)
		potion_instance.global_position = $Marker2D.global_position #spawn on player
		potion_velocity = Vector2(400,-200) #reset initial throw speeds after every throw
