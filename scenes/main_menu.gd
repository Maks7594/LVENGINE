extends Control

@onready var buttons = [$MainMenu/Play, $MainMenu/Settings, $MainMenu/Quit]

@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var mus_menu = $SFX/Music

var selection := 0

func _ready():
	PlayerVars.detect_ut()
	PlayerVars.load_settings()
	PlayerVars.apply_settings()
	
	Funcs.do_ut_music($SFX/Music, "mus_menu0.ogg", true)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		selection = (selection + 1 + 3) % 3
		Funcs.do_sound(snd_select)
		select(buttons[selection])
	elif Input.is_action_just_pressed("up"):
		selection = (selection - 1 + 3) % 3
		Funcs.do_sound(snd_select)
		select(buttons[selection])
	elif Input.is_action_just_pressed("confirm"):
		do_confirm()

func do_confirm():
	if selection == 0:
		get_tree().change_scene_to_file("res://scenes/rooms/room0.tscn")
	elif selection == 1:
		get_tree().change_scene_to_file("res://scenes/settings.tscn")
	elif selection == 2:
		get_tree().quit()

func select(btn: Node):
	for i in range(buttons.size()):
		if i == selection:
			buttons[i].modulate = Color("YELLOW")
		else:
			buttons[i].modulate = Color("WHITE")
