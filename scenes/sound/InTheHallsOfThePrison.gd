extends AudioStreamPlayer2D

var numbers = [1, 1, 1, 0.9, 1.1]

func _ready():
	finished.connect(_on_finished)
	
func _on_finished():
	randomize()
	self.pitch_scale = get_random_number()
	self.play()

func get_random_number():
	var index = randi() % numbers.size()
	return numbers[index]
