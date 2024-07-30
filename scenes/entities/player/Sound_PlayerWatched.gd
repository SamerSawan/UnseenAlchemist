extends AudioStreamPlayer2D

# This is for the music that plays when the player is watched or not

@onready var baseline_volume = get_volume_db()

# if watched, fade volume until at -60dB, then turn off
# else, fade volume back in

func fade_in():
	if !is_playing():
		set_volume_db(baseline_volume) # make sure to set back to baseline when playing again
		play()
		#print("watched music playing")
	#print("fading in player_watched_music")
	if get_volume_db() < baseline_volume:
		set_volume_db(get_volume_db() + 5)

func fade_out():
	#print("fading out player_watched_music")
	if get_volume_db() > -50.0:
		set_volume_db(get_volume_db() - 1)
	else:
		if is_playing():
			stop()
			#print("player_watched_music stopped")
