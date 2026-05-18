extends Node

const save_path = "user://settings.cfg"
var config = ConfigFile.new()

var settings = {
	"debug": false,
	
	"music": true,
	"sfx": true,
	"bigger_window": false
}

var other = {
	"undertale_detected": ""
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

func detect_ut():
	print("Detecting UNDERTALE on " + OS.get_name())
	
	var win_path = "C:/Program Files (x86)/Steam/steamapps/common/Undertale/"
	var linux_path = OS.get_environment("HOME") + "/.steam/steam/steamapps/common/Undertale/assets/"
	
	match OS.get_name():
		"Windows":
			print("Checking path: " + win_path)
			if DirAccess.dir_exists_absolute(win_path):
				print("Detected Undertale at " + win_path + "!")
				PlayerVars.other["undertale_detected"] = win_path
			else:
				print("Couldn't detect Undertale or not installed!")
		"Linux":
			print("Checking path: " + linux_path)
			if DirAccess.dir_exists_absolute(linux_path):
				print("Detected Undertale at " + linux_path + "!")
				PlayerVars.other["undertale_detected"] = linux_path
			else:
				print("Couldn't detect Undertale or not installed!")
		_:
			print("Unsupported OS! Couldn't detect Undertale!")
