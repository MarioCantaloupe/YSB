extends AudioStreamPlayer

func play_music(music: AudioStream):
	if stream == music and playing:
		return
	stream = music
	play()

func stop_music():
	stop()
