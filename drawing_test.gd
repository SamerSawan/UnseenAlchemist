extends Line2D

var gravity
var dir
var speed
var velocity: Vector2
var player
var potion_thrower
var to_be_thrown: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	potion_thrower = get_tree().get_first_node_in_group("potion_thrower")
	gravity = player.gravity_value
	SignalBus.update_drinkability.connect(drinkability)

func _physics_process(delta):
	queue_redraw() #should only be visible if potion is equipped
	if visible && to_be_thrown: #fortunately works as is
		player.player_sprite.flip_h = get_forward_direction().x < 0

func _draw():
	if to_be_thrown: #somehow works
		update_trajectory()

func get_forward_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func update_trajectory() -> void:
	velocity = potion_thrower.potion_velocity.x * get_forward_direction()
	var line_start := global_position
	var line_end: Vector2
	var drag:float = 0 #dunno what this is here for really cos i have 0 drag
	var timestep := 0.02
	var colors := [Color.RED, Color.BLUE]
	
	for i in 70: #whatever this means, believe its number of points
		velocity.y += gravity * timestep
		line_end = line_start + (velocity*timestep)
		velocity = velocity * clampf(1.0 - drag*timestep, 0, 1)
		
		var ray := raycast_query2d(line_start, line_end)
		if not ray.is_empty():
			break
		
		draw_line_global(line_start, line_end, colors[i%2])
		line_start = line_end

func raycast_query2d(pointA:Vector2, pointB:Vector2) -> Dictionary: #stop line at collision
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(pointA, pointB, 8)
	var result := space_state.intersect_ray(query)
	if result:
		return result
		
	return{}

func draw_line_global(pointA:Vector2, pointB:Vector2, color:Color, width:int = -1) -> void:
	var local_offest := pointA - global_position
	var pointB_local := pointB - global_position
	draw_line(local_offest, pointB_local, color, width)

func drinkability():
	if potion_thrower.drinkable_potion || (potion_thrower.potion_resource == null):
		to_be_thrown = false
	else:
		to_be_thrown = true
		
func _input(event): #avoid confusion from right-clicking with a drinkable
	if event.is_action_released("RightClick") && to_be_thrown: 
		visible = !visible
