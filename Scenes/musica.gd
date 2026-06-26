extends AudioStreamPlayer



func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_music_level(Cancion : String):
	var musica = load(Cancion)
	_play_music(musica)
