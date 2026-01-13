extends AudioStreamPlayer

func play_music(music: AudioStream, time:=0.5):
	if stream == music and  playing:
		return
	
	if playing:
		var tween = create_tween()
		tween.tween_property(self,"volume_db", -80, time)
		tween.finished.connect(func():
			stream=music
			play()
			volume_db=-80
			create_tween().tween_property(self, "volume_db", 0, time)
		)
	else:
		stream=music
		play()

func stop_music():
	stop()
