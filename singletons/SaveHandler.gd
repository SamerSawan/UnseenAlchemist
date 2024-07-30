extends Node

# this file is basically copied from the godot docs
# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

const SAVE_GAME_PATH := "user://savegame.save"

func new_game():
	if FileAccess.file_exists(SAVE_GAME_PATH):
		DirAccess.remove_absolute(SAVE_GAME_PATH)
	get_tree().change_scene_to_file("res://scenes/Stages/tutorial.tscn")
	save_game()

func save_game():
	# fileaccess creates file if doesnt exist already
	var save_file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE) 
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node" + node.name + "is not an instanced scene, skipped")
			continue
		if !node.has_method("save"):
			print("persistent node" + node.name + "is missing a save() function, skipped")
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		save_file.store_line(json_string)
	
	print("Game saved")

func load_game():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
			
	print("Game loaded")
