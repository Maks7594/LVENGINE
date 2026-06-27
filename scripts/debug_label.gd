extends Label

func _process(_delta):
	text = "* If you're cuter, monsters[br]  won't hit you as hard."
	#text = \
	#"LVENGINE v0.0.1\n" + \
	#"pos: " + str($"../../World/Player".position) + "\n" + \
	#"interact:" + str(PlayerData.global["interact"]) + "\n" + \
	#"menu open:" + str(PlayerData.global["menu_open"]) + "\n" + \
	#"is typing:" + str($"../../World/UI".typewriter.is_typing()) + "\n" + \
	#"is finished:" + str($"../../World/UI".typewriter.is_finished()) + "\n"
