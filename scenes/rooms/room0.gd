extends Node2D

func _ready():
	if PlayerVars.settings["music"]:
		$SFX/Music.play()
