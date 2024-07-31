extends Node2D

var player
var player_entered #toggle raycast tracking
var is_sleep = false
var spotted_once: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_to_player = $StaticBody2D/RayCast2D
@onready var killtimer = $KillTimer

func _ready():
	player = get_tree().get_first_node_in_group("player")
	SignalBus.is_slept.connect(fell_asleep)
	SignalBus.is_awake.connect(woke_up)
	
func _physics_process(_delta):
	if !player.is_statue:
		player_detection()

func fell_asleep():
	if is_sleep:
		animated_sprite_2d.play("sleep")
		player.watched = false

func woke_up():
	animated_sprite_2d.play("idle")


func _on_detection_area_body_entered(body):
	if body.name == "Player": #should only apply to player
		ray_to_player.set_deferred("enabled",true)
		player_entered = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		ray_to_player.set_deferred("enabled",false)
		player_entered = false
		player.watched = false
		killtimer.stop()
		player.watcher_particles.emitting = false
	
func player_detection():
	if player_entered == true and !is_sleep and !player.is_statue: #points raycast to the player
		ray_to_player.set_target_position(player.global_position - ray_to_player.global_position)
		if ray_to_player.is_colliding() && ray_to_player.get_collider() == player && !player.is_invisible: #checks if first object hit is player
			if !spotted_once:
				spotted_once = true
				player.watched = true
				killtimer.start()
				player.watcher_particles.emitting = true
		else:
			if spotted_once:
				spotted_once = false
				killtimer.stop()
				player.watched = false
				player.watcher_particles.emitting = false

func _on_kill_timer_timeout():
	SignalBus.player_died.emit()
