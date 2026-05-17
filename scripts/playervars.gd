extends Node

const save_path = "user://settings.cfg"
var config = ConfigFile.new()

var settings = {
	"debug": false,
	
	"music": true,
	"sfx": true,
	"bigger_window": true,
}

func save_settings():
	print("Saving settings...")
	for key in settings.keys():
		config.set_value("options", key, settings[key])
	config.save(save_path)
	print("Settings saved!")

func load_settings():
	print("Loading settings...")
	var status = config.load(save_path)
	if status != OK:
		push_error("Failed to load settings!")
		return
	
	for key in settings.keys():
		settings[key] = config.get_value("options", key, settings[key])
	print("Settings loaded!")

func apply_settings():
	print("Applying settings...")
	
	if settings["bigger_window"]:
		get_window().size = Vector2i(1280, 960)
	else:
		get_window().size = Vector2i(640, 480)
	
	get_window().move_to_center()
