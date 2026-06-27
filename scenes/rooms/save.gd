extends NPC

func _ready():
	$Sprite2D.play()

func interact():
	PlayerData.global["interact"] = false
	$"/root/SFX/Save".play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit(1)
