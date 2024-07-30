extends RigidBody2D

var currentPotion : String
@onready var sprite_2d = $Sprite2D
var potion_parent
var player_parent
var smoke = preload("res://scenes/entities/environment/Potions/smoke.tscn")
var sleep = preload("res://scenes/entities/environment/Potions/sleep.tscn")
var slime = preload("res://scenes/entities/environment/Potions/Slime.tscn")
var strength = preload("res://scenes/entities/environment/Potions/strength.tscn")

func _ready():
	potion_parent = get_tree().get_first_node_in_group("potion_thrower")
	player_parent = get_tree().get_first_node_in_group("Player")
	linear_velocity = potion_parent.potion_velocity
	if potion_parent.potion_resource:
		currentPotion = potion_parent.potion_resource.name
		match currentPotion:
			"InvisPotion":
				sprite_2d.frame = 0
			"SlimePotion":
				sprite_2d.frame = 1
			"StatuePotion":
				sprite_2d.frame = 2
			"SmokePotion":
				sprite_2d.frame = 3
			"StrengthPotion":
				sprite_2d.frame = 4
			"NoisePotion":
				sprite_2d.frame = 5
			"DashPotion":
				sprite_2d.frame = 6
			"SleepPotion":
				sprite_2d.frame = 7

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.lose_hp()
		body.hp_label_update()
	
	var sound_queue = get_node("SoundQueue_PotionShatter")
	sound_queue.reparent(get_node("/root"), true)
	sound_queue.play_sound()
	match currentPotion:
			"InvisPotion":
				SignalBus.activate_invis.emit()
			"SlimePotion":
				var slime_instance = slime.instantiate()
				potion_parent.potion_container.call_deferred("add_child", slime_instance)
				slime_instance.global_position = global_position
			"StatuePotion":
				SignalBus.activate_statue.emit()
			"SmokePotion":
				var smoke_instance = smoke.instantiate()
				potion_parent.potion_container.call_deferred("add_child", smoke_instance)
				smoke_instance.global_position = global_position
			"StrengthPotion":
				SignalBus.activate_strength.emit()
			"NoisePotion":
				pass
			"DashPotion":
				SignalBus.activate_dash.emit()
			"SleepPotion":
				var sleep_instance = sleep.instantiate()
				potion_parent.potion_container.call_deferred("add_child", sleep_instance)
				sleep_instance.global_position = global_position
	queue_free() 
	
