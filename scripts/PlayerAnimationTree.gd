extends AnimationTree

enum {
	IDLE,
	RUN,
	WINDUP,
	THROW,
	DIE,
	JUMP,
	FALL,
	PUSH,
}

var state
var new_state
var player

func _ready():
	state = IDLE
	player = get_tree().get_first_node_in_group("player")
	SignalBus.anim_state_change.connect(change_state)

#func _process(delta):
#	print(state)
func change_state():
	if state != DIE: #deathzone wont work without this
		state = player.new_state
