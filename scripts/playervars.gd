extends Node

const save_path = "user://settings.cfg"
var config = ConfigFile.new()

var settings = {
	"max_fps": 30,
	"music": true,
	"sfx": true,
	"bigger_window": true,
	"locale": "pl_pl"
}

func save_settings():
	for key in settings.keys():
		config.set_value("options", key, settings[key])
	config.save(save_path)

func load_settings():
	var status = config.load(save_path)
	if status != OK:
		return
	
	for key in settings.keys():
		settings[key] = config.get_value("options", key, settings[key])

func apply_settings():
	Engine.max_fps = settings["max_fps"]
	
	if settings["bigger_window"]:
		get_window().size = Vector2i(1280, 960)
	else:
		get_window().size = Vector2i(640, 480)
	get_window().move_to_center()
