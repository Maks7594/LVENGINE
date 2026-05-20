extends CanvasLayer

@onready var bm = $".."

@onready var soul = $Soul

@onready var music = $SFX/Music
@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var snd_hurt = $SFX/Hurt
@onready var snd_stab = $SFX/Stab

@onready var typewriter = $Dialogue

@onready var quick_ui = [
	$PlayerName,
	$PlayerLove,
	$PlayerHP,
	$PlayerHPBar
]

@onready var buttons = [
	$Fight,
	$Act,
	$Item,
	$Mercy
]

@onready var options = [
	$Option1,
	$Option2,
	$Option3,
	$Option4,
	$Option5,
	$Option6
]

var btn_selection := 0
var option_selection := 0
var submenu := 0
var subsubmenu := 0
var items_page := 0

func _ready():
	update_ui()

func update_ui():
	$PlayerName.text = PlayerData.player["name"]
	$PlayerLove.position.x = $PlayerName.size.x + 60
	$PlayerLove.text = "LV %d" % PlayerData.player["love"]
	$PlayerHP.text = "%d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	if submenu == 0:
		select_btn(buttons[btn_selection])

func select_btn(btn: TextureRect):
	if btn_selection == 1:
		soul.position.x = btn.global_position.x + 18
	else:
		soul.position.x = btn.global_position.x + 16
		
	soul.position.y = btn.global_position.y + 21
	if submenu == 0:
		for i in range(buttons.size()):
			if btn_selection == i:
				buttons[i].texture = load("res://images/battle/%ds.png" % i) 
			else:
				buttons[i].texture = load("res://images/battle/%d.png" % i) 

func select_option():
	for i in range(options.size()):
		if option_selection == i:
			soul.position.x = options[i].position.x - 24
			soul.position.y = options[i].position.y + 17

func do_confirm():
	if submenu == 0:
		if btn_selection == 3:
			Funcs.do_sound(snd_confirm)
			do_submenu(3, true)
			submenu = 3
			select_option()
	elif submenu == 4:
		if option_selection == 0:
			pass

func do_submenu(sub_menu, show_opt):
	if show_opt:
		typewriter.visible = false
		for i in range(options.size()):
			options[i].visible = true
	else:
		typewriter.visible = true
		for i in range(options.size()):
			options[i].visible = false
	if sub_menu == 0:
		submenu = 0
	if sub_menu == 3:
		if bm.enemy_mercy == 100:
			options[0].modulate = Color(1, 1, 0, 1)
			options[0].text = "* Spare"
		else:
			options[0].modulate = Color(1, 1, 1, 1)
			options[0].text = "* Spare"
		options[1].text = "* Flee"
		
		options[2].visible = false
		options[3].visible = false
		options[4].visible = false
		options[5].visible = false

func _input(event):
	if submenu == 0:
		if event.is_action_pressed("right"):
			btn_selection = (btn_selection + 1 + 4) % 4
			Funcs.do_sound(snd_select)
			select_btn(buttons[btn_selection])
		elif event.is_action_pressed("left"):
			btn_selection = (btn_selection - 1 + 4) % 4
			Funcs.do_sound(snd_select)
			select_btn(buttons[btn_selection])
		elif event.is_action_pressed("confirm"):
			do_confirm()
	elif submenu == 1:
		pass
	elif submenu == 2:
		pass
	elif submenu == 3:
		if event.is_action_pressed("right"):
			option_selection = (option_selection + 1 + 2) % 2
			Funcs.do_sound(snd_select)
			select_option()
		elif event.is_action_pressed("left"):
			option_selection = (option_selection - 1 + 2) % 2
			Funcs.do_sound(snd_select)
			select_option()
		elif event.is_action_pressed("confirm"):
			do_confirm()
		elif event.is_action_pressed("cancel"):
			do_submenu(0, false)
			update_ui()
