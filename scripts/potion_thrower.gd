extends Node2D

@onready var potion_container = $potion_container
@export var potion_velocity: Vector2 = Vector2(400,-200)
var potion = preload("res://scenes/entities/player/potion.tscn")
var player
var indicator_rotator: float = 20

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	aim_potion(delta)
#	queue_redraw()
	#had to rearrange a lot of code below to get cancelling to work
func aim_potion(delta): #hold to wind up throw 
	if Input.is_action_pressed("Shoot") && player.is_on_floor():
		if Input.is_action_pressed("MoveRight") || Input.is_action_pressed("MoveLeft") || Input.is_action_pressed("Jump"):
			player.change_animation_state(0) #default to idle if movement being pressed
			potion_velocity = Vector2(400,-200) #reset initial throw speeds on cancel
			indicator_rotator = -20*player.last_direction.x
		elif potion_velocity.x > 0 && potion_velocity.y > -500: #why is this so complicated
			if Input.is_action_just_pressed("Shoot"): #to properly reset the indicator's position
				indicator_rotator = -20*player.last_direction.x
			potion_velocity.x -= (100 * delta) #decrease x velocity, increase y velocity
			potion_velocity.y -= (100 * delta)
			indicator_rotator -= 23*delta * player.last_direction.x #winds up while charging (guessed value)
			player.change_animation_state(2) #code for windup
	elif player.new_state == 2:
		shoot()

#func _draw(): #this is NOT happening
#	draw_line(player.position, potion_velocity/25, Color.GREEN, 10.0)
#	draw_arc(player.global_position,200,PI,2*PI,100,Color.GREEN,10.0)
	
func shoot():
	if Input.is_action_just_released("Shoot"): #fire on release
		potion_velocity.x *= player.last_direction.x
		player.change_animation_state(3) #code for throw
		var potion_instance = potion.instantiate()
		potion_container.add_child(potion_instance)
		potion_instance.global_position = $Marker2D.global_position #spawn on player
		potion_velocity = Vector2(400,-200) #reset initial throw speeds after every throw
