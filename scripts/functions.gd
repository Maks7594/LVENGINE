extends Node

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

func transition_room(room):
	var tween_in = Tween
