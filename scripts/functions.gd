extends Node

func do_sound(stream: AudioStreamPlayer):
	if PlayerVars.settings["sfx"]:
		stream.play()
	else:
		return
