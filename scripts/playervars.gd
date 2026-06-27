extends Node

const save_path = "user://settings.cfg"
var config = ConfigFile.new()

var settings = {
	"debug": true,
	
	"music": true,
	"sfx": true,
	"bigger_window": false,
	"fullscreen": false
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

func detect_ut() -> String:
	print("Detecting UNDERTALE on " + OS.get_name())
	
	var win_path = "C:/Program Files (x86)/Steam/steamapps/common/Undertale/"
	var linux_path = OS.get_environment("HOME") + "/.steam/steam/steamapps/common/Undertale/assets/"
	
	match OS.get_name():
		"Windows":
			# print("Checking path: " + win_path)
			if DirAccess.dir_exists_absolute(win_path):
				# print("Detected Undertale at " + win_path + "!")
				PlayerVars.other["undertale_detected"] = win_path
				return win_path
			else:
				# print("Couldn't detect Undertale or not installed!")
				return ""
		"Linux":
			# print("Checking path: " + linux_path)
			if DirAccess.dir_exists_absolute(linux_path):
				# print("Detected Undertale at " + linux_path + "!")
				PlayerVars.other["undertale_detected"] = linux_path
				return linux_path
			else:
				# print("Couldn't detect Undertale or not installed!")
				return ""
		"Web":
			print("Cannot detect Undertale on Web. Please use an standalone version.")
			return ""
		_:
			print("Unsupported OS %s! Couldn't detect Undertale!" % OS.get_name())
			return ""

func fs_toggle():
	settings["fullscreen"] = not settings["fullscreen"]
	# print("fullscreen:" + str(settings["fullscreen"]))
	if not settings["fullscreen"]:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if settings["bigger_window"]:
			get_window().size = Vector2i(1280, 960)
		else:
			get_window().size = Vector2i(640, 480)
		get_window().move_to_center()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		get_window().size = DisplayServer.screen_get_size()
