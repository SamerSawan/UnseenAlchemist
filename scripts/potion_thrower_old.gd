extends Node2D

@onready var potion_container = $potion_container
@export var potion_velocity: Vector2 = Vector2(500,-100)
var potion = preload("res://scenes/entities/player/potion.tscn")
var hotbar = preload("res://Inventory/HotBar.tres")
var player
var indicator_rotator: float = 20
var potion_resource = SignalBus.equipped_potion
var drinkable_potion: bool = false
var is_aiming: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	SignalBus.potion_changed.connect(update_potion)
	
func _physics_process(delta):
	if potion_resource != null:
		if !player.is_statue && !drinkable_potion: #for throwing
			aim_potion(delta)
		elif !player.is_statue && drinkable_potion: #for a delish bev
			drink()

func update_potion(): #two of the if statements of all time
	potion_resource = SignalBus.equipped_potion
	if potion_resource != null:
		if (potion_resource.name == "InvisPotion")||(potion_resource.name == "StatuePotion")||(potion_resource.name == "StrengthPotion")||(potion_resource.name == "DashPotion"):
			drinkable_potion = true
		elif (potion_resource.name == "SlimePotion")||(potion_resource.name == "SmokePotion")||(potion_resource.name == "NoisePotion")||(potion_resource.name == "SleepPotion"):
			drinkable_potion = false
	

func aim_potion(delta): #hold to wind up throw 
	if Input.is_action_pressed("Shoot") && player.is_on_floor() && player.velocity.x == 0:
		if Input.is_action_pressed("MoveRight") || Input.is_action_pressed("MoveLeft") || Input.is_action_pressed("Jump"):
			player.change_animation_state(0) #cancel throw
			potion_velocity = Vector2(500,-100) #reset initial throw speeds on cancel
#			indicator_rotator = 20*player.last_direction.x
			is_aiming = false
		elif potion_velocity.x > 0 && potion_velocity.y > -500: #charge up throw
#			if Input.is_action_just_pressed("Shoot"): #to properly reset the indicator's position
#				indicator_rotator = -20*player.last_direction.x
			potion_velocity.x -= (150 * delta) #decrease x velocity, increase y velocity
			potion_velocity.y -= (201 * delta)
#			indicator_rotator -= 46*delta * player.last_direction.x #winds up while charging (guessed value)
			player.change_animation_state(2) #code for windup
			is_aiming = true
	elif player.new_state == 2:
		shoot()

func drink():
	if Input.is_action_just_pressed("Shoot") && player.is_on_floor(): #THROWS STRAIGHT DOWN
		player.change_animation_state(3)
		var potion_instance = potion.instantiate()
		hotbar.remove(potion_resource)
		potion_container.add_child(potion_instance)
		potion_instance.global_position = $Marker2D.global_position
#		indicator_rotator = -20*player.last_direction.x
		potion_velocity = Vector2(500,-100)

func shoot():
	if !player.is_statue and Input.is_action_just_released("Shoot"): #fire on release
		potion_velocity.x *= player.last_direction.x
		player.change_animation_state(3) #code for throw
		var potion_instance = potion.instantiate()
		hotbar.remove(potion_resource)
		potion_container.add_child(potion_instance)
		potion_instance.global_position = $Marker2D.global_position #spawn on player
#		indicator_rotator = -20*player.last_direction.x
		potion_velocity = Vector2(500,-100) #reset initial throw speeds after every throw
		is_aiming = false
