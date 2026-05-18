extends Control

@onready var buttons = [$Settings/OptionsList/Exit, $Settings/OptionsList/Music, $Settings/OptionsList/SFX, $Settings/OptionsList/BiggerWindow]

@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var snd_harp = $SFX/Harp
@onready var mus_menu = $SFX/Music

var selection := 0

func unsheathe():
	var bb1 = $Settings/BlackBar
	var bb2 = $Settings/BlackBar2
	
	var tween1 = create_tween()
	tween1.tween_property(bb1, "position:x", 320, 1.5)
	
	var tween2 = create_tween()
	tween2.tween_property(bb2, "position:x", -640, 1.5)

func snd():
	if PlayerVars.other["undertale_detected"] != "":
		print("Trying path " + PlayerVars.other["undertale_detected"] + "mus_options_fall.ogg")
		var mus_bytes: PackedByteArray = FileAccess.get_file_as_bytes(PlayerVars.other["undertale_detected"] + "mus_options_fall.ogg")
		if mus_bytes.is_empty():
			print("Music file is empty!")
			$Settings/MusErrorLabel.visible = true
			return
		var mus_stream := AudioStreamOggVorbis.load_from_buffer(mus_bytes)
		mus_stream.loop = true
		mus_menu.stream = mus_stream
		
	Funcs.do_sound(snd_harp)
	await get_tree().create_timer(1.5).timeout
	Funcs.do_music(mus_menu)

func _ready():
	PlayerVars.detect_ut()
	
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	
	snd()
	unsheathe()
	
	buttons[1].text = "Music: " + str(PlayerVars.settings["music"])
	buttons[2].text = "Sound: " + str(PlayerVars.settings["sfx"])
	buttons[3].text = "Bigger Window: " + str(PlayerVars.settings["bigger_window"])

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
		PlayerVars.save_settings()
		PlayerVars.apply_settings()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif selection == 1:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["music"] = false if PlayerVars.settings["music"] == true else true
		buttons[1].text = "Music: " + str(PlayerVars.settings["music"])
		
		if not PlayerVars.settings["music"] and mus_menu.playing:
			mus_menu.playing = false
		elif PlayerVars.settings["music"] and not mus_menu.playing:
			mus_menu.playing = true
	elif selection == 2:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["sfx"] = false if PlayerVars.settings["sfx"] == true else true
		buttons[2].text = "Sound: " + str(PlayerVars.settings["sfx"])
	elif selection == 3:
		Funcs.do_sound(snd_confirm)
		PlayerVars.settings["bigger_window"] = false if PlayerVars.settings["bigger_window"] == true else true
		buttons[3].text = "Bigger Window: " + str(PlayerVars.settings["bigger_window"])

func select(btn: Node):
	for i in range(buttons.size()):
		if i == selection:
			buttons[i].modulate = Color("YELLOW")
		else:
			buttons[i].modulate = Color("WHITE")
