extends Control

@onready var soul = $Soul

@onready var main_menu = $MainMenu
@onready var settings_menu = $Settings 

@onready var buttons = [$MainMenu/Play, $MainMenu/Settings, $MainMenu/Quit]
@onready var settings_buttons = [$Settings/OptionsList/MaxFPS, $Settings/OptionsList/Music, $Settings/OptionsList/SFX, $Settings/OptionsList/BiggerWindow, $Settings/Back]

@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var mus_menu = $SFX/Music

var selection := 0
var in_settings := false

func _ready():
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	
	if PlayerVars.settings["music"]:
		$SFX/Music.play()
	else:
		return
	
	$Settings/OptionsList/Music.text = "Music: " + str(PlayerVars.settings["music"])
	$Settings/OptionsList/SFX.text = "Sound: " + str(PlayerVars.settings["sfx"])
	$Settings/OptionsList/BiggerWindow.text = "Bigger Window: " + str(PlayerVars.settings["bigger_window"])

func _process(_delta: float) -> void:
	if not in_settings:
		if Input.is_action_just_pressed("down"):
			selection = (selection + 1 + 3) % 3
			Funcs.do_sound(snd_select)
		elif Input.is_action_just_pressed("up"):
			selection = (selection - 1 + 3) % 3
			Funcs.do_sound(snd_select)
		elif Input.is_action_just_pressed("confirm"):
			do_confirm()
	else:
		if Input.is_action_just_pressed("down"):
			selection = (selection + 1 + 5) % 5
			Funcs.do_sound(snd_select)
		elif Input.is_action_just_pressed("up"):
			selection = (selection - 1 + 5) % 5
			Funcs.do_sound(snd_select)
		elif Input.is_action_just_pressed("confirm"):
			do_confirm()
		
	if not in_settings:
		for i in range(buttons.size()):
			if i == selection:
				select(buttons[i])
				buttons[i].modulate = Color("YELLOW")
			else:
				buttons[i].modulate = Color("WHITE")
	else:
		for i in range(settings_buttons.size()):
			if i == selection:
				select(settings_buttons[i])
				settings_buttons[i].modulate = Color("YELLOW")
			else:
				settings_buttons[i].modulate = Color("WHITE")

func do_confirm():
	if not in_settings:
		if selection == 0:
			Funcs.do_sound(snd_confirm)
			get_tree().change_scene_to_file("res://scenes/rooms/room0.tscn")
		elif selection == 1:
			Funcs.do_sound(snd_confirm)
			settings_toggle()
		elif selection == 2:
			Funcs.do_sound(snd_confirm)
			get_tree().quit(0)
	else:
		if selection == 0:
			Funcs.do_sound(snd_confirm)
			PlayerVars.settings["max_fps"] = 60 if PlayerVars.settings["max_fps"] == 30 else 30
			settings_buttons[0].text = "Max FPS: " + str(PlayerVars.settings["max_fps"])
		elif selection == 1:
			Funcs.do_sound(snd_confirm)
			PlayerVars.settings["music"] = false if PlayerVars.settings["music"] == true else true
			settings_buttons[1].text = "Music: " + str(PlayerVars.settings["music"])
			
			if not PlayerVars.settings["music"] and mus_menu.playing:
				mus_menu.playing = false
			elif PlayerVars.settings["music"] and not mus_menu.playing:
				mus_menu.playing = true
		elif selection == 2:
			Funcs.do_sound(snd_confirm)
			PlayerVars.settings["sfx"] = false if PlayerVars.settings["sfx"] == true else true
			settings_buttons[2].text = "Sound: " + str(PlayerVars.settings["sfx"])
		elif selection == 3:
			Funcs.do_sound(snd_confirm)
			PlayerVars.settings["bigger_window"] = false if PlayerVars.settings["bigger_window"] == true else true
			settings_buttons[3].text = "Bigger Window: " + str(PlayerVars.settings["bigger_window"])
		elif selection == 4:
			Funcs.do_sound(snd_confirm)
			PlayerVars.save_settings()
			PlayerVars.apply_settings()
			settings_toggle()

func settings_toggle():
	if not in_settings:
		in_settings = true
		$MainMenu.visible = false
		selection = 0
		$Settings.visible = true
	else:
		in_settings = false
		selection = 0
		$MainMenu.visible = true
		$Settings.visible = false

func select(btn: Node):
	soul.global_position.x = btn.global_position.x - soul.size.x - 10
	soul.global_position.y = btn.global_position.y + 9
