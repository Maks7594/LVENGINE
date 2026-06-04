extends Control

@onready var buttons = [$Settings/OptionsList/Exit, $Settings/OptionsList/Apply, $Settings/OptionsList/Music, $Settings/OptionsList/SFX, $Settings/OptionsList/BiggerWindow]

@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var snd_harp = $SFX/Harp
@onready var mus_settings = $SFX/Music

var texts = [
	"godot > unity fr fr",
	"ok but linux\ndoesnt force u to\npay to use it",
]

var selection := 0

func txt():
	buttons[1].text = "SETTINGS APPLIED!"
	await get_tree().create_timer(1).timeout
	buttons[1].text = "APPLY"

func unsheathe():
	var bb1 = $Settings/BlackBar
	var bb2 = $Settings/BlackBar2
	
	var tween1 = create_tween()
	tween1.tween_property(bb1, "position:x", 320, 1.5)
	
	var tween2 = create_tween()
	tween2.tween_property(bb2, "position:x", -640, 1.5)

func snd(): 
	var mus = "mus_options_fall.ogg" # Default
	
	# Roll random number
	# var random = randi_range(1, 25)
	var random = 10
	print(random)
	
	if random == 10:
		$Settings/Dog.visible = false
		$Settings/DogSanctuary.visible = true
		$Settings/DogLabel.position.y = -50
		mus_settings.stream = load("res://music/mus_options_sanctuary.ogg")
		mus_settings.stream.loop = true
		$Settings/DogLabel.text = "[tornado radius=10.0 freq=2.0 connected=1]dark sanctuaries\nare in undertale\nyou just cant make\na dark world[/tornado]"
		$Settings/Dog.animation = "spring"
		Funcs.do_sound(snd_harp)
		await get_tree().create_timer(1.5).timeout
		Funcs.do_music(mus_settings)
		return
	
	# Match month to season
	match Time.get_date_dict_from_system()["month"]:
		3, 4, 5: # Spring
			mus = "mus_options_fall.ogg"
			$Settings/DogLabel.text = "[tornado radius=10.0 freq=2.0 connected=1]spring time\nback to school[/tornado]"
			$Settings/Dog.animation = "spring"
		6, 7, 8: # Summer
			mus = "mus_options_summer.ogg"
			$Settings/DogLabel.text = "[tornado radius=10.0 freq=2.0 connected=1]try to withstand\nthe sun's life-\ngiving rays[/tornado]"
			$Settings/Dog.animation = "summer"
		9, 10, 11: # Fall
			mus = "mus_options_fall.ogg"
			$Settings/DogLabel.text = "[tornado radius=10.0 freq=2.0 connected=1]sweep a leaf\nsweep away a troubles[/tornado]"
			$Settings/Dog.animation = "fall"
		12, 1, 2: # Winter
			mus = "mus_options_winter.ogg"
			$Settings/DogLabel.text = "[tornado radius=10.0 freq=2.0 connected=1]cold outside\nbut stay warm\ninside of you[/tornado]"
			$Settings/Dog.animation = "winter"
	if PlayerVars.other["undertale_detected"] != "": # If we detected the Undertale installation
		# print("Trying path " + PlayerVars.other["undertale_detected"] + mus)
		var mus_bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + mus)
		if mus_bytes.is_empty():
			print("Couldn't load music!")
			return
		var mus_stream := AudioStreamOggVorbis.load_from_buffer(mus_bytes)
		mus_stream.loop = true
		mus_settings.stream = mus_stream
	else:
		$Settings/MusErrorLabel.visible = true
		
	Funcs.do_sound(snd_harp)
	await get_tree().create_timer(1.5).timeout
	Funcs.do_music(mus_settings)

func _ready():
	PlayerVars.detect_ut()
	
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	
	snd()
	$Settings/Dog.play()
	unsheathe()
	
	buttons[2].text = "Music: " + str(PlayerVars.settings["music"])
	buttons[3].text = "Sound: " + str(PlayerVars.settings["sfx"])
	buttons[4].text = "Window Scale: 2x" if PlayerVars.settings["bigger_window"] else "Window Scale: 1x"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		selection = (selection + 1 + buttons.size()) % buttons.size()
		Funcs.do_sound(snd_select)
		select(buttons[selection])
	elif Input.is_action_just_pressed("up"):
		selection = (selection - 1 + buttons.size()) % buttons.size()
		Funcs.do_sound(snd_select)
		select(buttons[selection])
	elif Input.is_action_just_pressed("confirm"):
		do_confirm()

func do_confirm():
	if selection == 0:
		Funcs.do_sound(snd_confirm)
		
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif selection == 1:
		Funcs.do_sound(snd_confirm)
		PlayerVars.save_settings()
		txt()
		PlayerVars.apply_settings()
	elif selection == 2:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["music"] = false if PlayerVars.settings["music"] == true else true
		buttons[selection].text = "Music: " + str(PlayerVars.settings["music"])
		
		if not PlayerVars.settings["music"] and mus_settings.playing:
			mus_settings.playing = false
		elif PlayerVars.settings["music"] and not mus_settings.playing:
			mus_settings.playing = true
	elif selection == 3:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["sfx"] = false if PlayerVars.settings["sfx"] == true else true
		buttons[selection].text = "Sound: " + str(PlayerVars.settings["sfx"])
	elif selection == 4:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["bigger_window"] = false if PlayerVars.settings["bigger_window"] == true else true
		buttons[selection].text = "Window Scale: 2x" if PlayerVars.settings["bigger_window"] else "Window Scale: 1x"

func select(btn: Node):
	for i in range(buttons.size()):
		if i == selection:
			buttons[i].modulate = Color("YELLOW")
		else:
			buttons[i].modulate = Color("WHITE")
