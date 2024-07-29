extends Node2D

#attach a text node to this and it will fade in and out

@export var text : Node
@export var max_distance : float = 300.0
@export var fade_speed: float = 1.0

@onready var area2d : Area2D = get_node("Area2D")

var is_inside_area = false
var player_body : CharacterBody2D

func _ready():
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)

func _process(delta):
	if is_inside_area and player_body: # player is in area, and player body is availabe
		var distance = area2d.global_position.distance_to(player_body.global_position)
		var alpha = 1.0 - clamp(distance / max_distance, 0.0, 1.0)
		text.modulate.a = alpha
	else:
		text.modulate.a = max(0.0, text.modulate.a - fade_speed * delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_body = body
		is_inside_area = true

func _on_body_exited(body):
	if body == player_body:
		is_inside_area = false
		player_body = null
