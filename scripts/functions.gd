extends Node

func _input(event):
	if event.is_action_pressed("fullscreen"):
		PlayerVars.fs_toggle()

func do_sound(stream: AudioStreamPlayer):
	if PlayerVars.settings["sfx"]:
		if not stream == null:
			stream.play()
		else:
			push_error("Tried to play " + str(stream) + " but is null!")
	else:
		return

func do_music(stream: AudioStreamPlayer):
	if PlayerVars.settings["music"]:
		if not stream == null:
			stream.play()
		else:
			push_error("Tried to play " + str(stream) + " but is null!")
	else:
		return

func do_ut_music(player: AudioStreamPlayer, song: String, looping: bool):
	if player == null:
		print("Couldn't play %s because the player is null!" % song)
		return
	if PlayerVars.other["undertale_detected"] != "": # If we detected the Undertale installation
		print("Trying path " + PlayerVars.other["undertale_detected"] + song)
		var bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + song)
		if bytes.is_empty():
			print("Couldn't load music!")
			return
		var stream := AudioStreamOggVorbis.load_from_buffer(bytes)
		stream.loop = looping
		player.stream = stream
		player.play()

func transition_room(room):
	var tween_in = Tween
