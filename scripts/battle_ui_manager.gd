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

var options_cnt = 0
var items_page := 0

var text_done = false

func _on_typewriting_done():
	text_done = true

func _process(_delta):
	$Label.text = str(option_selection)

func _ready():
	update_ui()

func update_ui():
	$PlayerName.text = PlayerData.player["name"]
	$PlayerLove.position.x = $PlayerName.size.x + 60
	$PlayerLove.text = "LV %d" % PlayerData.player["love"]
	$PlayerHP.text = "%d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	$PlayerHPBar.value = PlayerData.player["hp"]
	$PlayerHPBar.max_value = PlayerData.player["max_hp"]
	if submenu == 0:
		select_btn(buttons[btn_selection])

func do_textbox(text: String):
	PlayerData.global["interact"] = false
	typewriter.visible = true
	typewriter.typewrite(text)

func select_btn(btn: TextureRect):
	soul.position.y = btn.global_position.y + 21
	if btn_selection == 1:
		soul.position.x = btn.global_position.x + 18
	else:
		soul.position.x = btn.global_position.x + 16
		
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
	if bm.plr_turn:
		if submenu == 0:
			if btn_selection == 0:
				Funcs.do_sound(snd_confirm)
				do_submenu(1, true)
				submenu = 1
				select_option()
			elif btn_selection == 1:
				Funcs.do_sound(snd_confirm)
				do_submenu(2, true)
				submenu = 2
				select_option()
			elif btn_selection == 2:
				Funcs.do_sound(snd_confirm)
				do_submenu(3, true)
				submenu = 3
				select_option()
			elif btn_selection == 3:
				Funcs.do_sound(snd_confirm)
				do_submenu(4, true)
				submenu = 4
				select_option()
		elif submenu == 2:
			Funcs.do_sound(snd_confirm)
			do_submenu(0, false)
			bm.plr_turn = false
			bm.do_act(option_selection)
		elif submenu == 4:
			if option_selection == 0:
				pass

func do_submenu(sub_menu: int, show_opt: bool):
	if show_opt:
		typewriter.visible = false
		for i in range(options.size()):
			options[i].visible = true
	else:
		typewriter.visible = true
		for i in range(options.size()):
			options[i].modulate = Color(1, 1, 1, 1)
			options[i].visible = false
	if sub_menu == 0:
		submenu = 0
	elif sub_menu == 1:
		options[1].visible = false
		options[2].visible = false
		options[3].visible = false
		options[4].visible = false
		options[5].visible = false
		
		options[0].text = "* %s" % bm.encounter["middle_enemy"]["name"]
		options[0].visible = true
	elif sub_menu == 2:
		for i in range(options.size()):
			options[i].modulate = Color(1, 1, 1, 1)
			options[i].visible = false
		
		var acts = bm.encounter["middle_enemy"]["acts"]
		var acts_range = range(0, acts)
		
		options_cnt = acts
		
		for i in acts_range:
			options[i].visible = true
			options[i].text = "* " + bm.encounter["middle_enemy"]["act%d_name" % (i + 1)]
	elif sub_menu == 3:
		for i in range(options.size()):
			options[i].modulate = Color(1, 1, 1, 1)
			options[i].visible = false
		
		options[0].visible = true
		options[1].visible = true
		options[2].visible = true
		options[3].visible = true
		options[4].visible = false
		if items_page == 0:
			options[0].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][0], "short_name")
			options[1].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][1], "short_name")
			options[2].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][2], "short_name")
			options[3].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][3], "short_name")
			options[5].text = "PAGE 1"
		else:
			options[0].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][4], "short_name")
			options[1].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][5], "short_name")
			options[2].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][6], "short_name")
			options[3].text = "* %s" % PlayerData.get_item_data(PlayerData.player["items"][7], "short_name")
			options[5].text = "PAGE 2"
		
	elif sub_menu == 4:
		for i in range(options.size()):
			options[i].modulate = Color(1, 1, 1, 1)
			options[i].visible = false
					
		options[0].visible = true
		options[2].visible = true
		if 100 == 100:
			options[0].modulate = Color(1, 1, 0, 1)
			options[0].text = "* Spare"
		else:
			options[0].modulate = Color(1, 1, 1, 1)
			options[0].text = "* Spare"
		options[2].text = "* Flee"

func _input(event):
	if bm.plr_turn:
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
			if event.is_action_pressed("cancel"):
				do_submenu(0, false)
				update_ui()
				option_selection = 0
		elif submenu == 2:
			if event.is_action_pressed("left"):
				if Funcs.is_odd(option_selection):
					option_selection = (option_selection - 1) % options_cnt
				else:
					option_selection = (option_selection + 1) % options_cnt
					
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("down"):
				option_selection = (option_selection + 2) % options_cnt
				
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("up"):
				option_selection = (option_selection - 2) % options_cnt
				if option_selection < 0:
					option_selection = 0
				
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("right"):
				if not Funcs.is_odd(option_selection):
					option_selection += 1
				else:
					option_selection -= 1
				
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("confirm"):
				do_confirm()
			elif event.is_action_pressed("cancel"):
				do_submenu(0, false)
				update_ui()
				option_selection = 0
		elif submenu == 3:
			if event.is_action_pressed("left"):
				if items_page == 1:
					if option_selection == 0 or option_selection == 2:
						items_page = 0
						do_submenu(3, true)
				
				if Funcs.is_odd(option_selection):
					option_selection -= 1
				else:
					option_selection += 1
					
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("right"):
				if items_page == 0:
					if option_selection == 1 or option_selection == 3:
						items_page = 1
						do_submenu(3, true)
				
				if not Funcs.is_odd(option_selection):
					option_selection += 1
				else:
					option_selection -= 1
				
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("down") or event.is_action_pressed("up"):
				option_selection = (option_selection + 2) % 4
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("confirm"):
				do_confirm()
			elif event.is_action_pressed("cancel"):
				do_submenu(0, false)
				update_ui()
				option_selection = 0
		elif submenu == 4:
			if event.is_action_pressed("down") or event.is_action_pressed("up"):
				option_selection = 2 if option_selection == 0 else 0
				Funcs.do_sound(snd_select)
				select_option()
			elif event.is_action_pressed("confirm"):
				do_confirm()
			elif event.is_action_pressed("cancel"):
				do_submenu(0, false)
				update_ui()
				option_selection = 0

func _physics_process(_delta):
	if typewriter.visible:
		if typewriter.is_typing():
			if Input.is_action_pressed("cancel"):
				typewriter.skip_typing()
		else:
			if text_done and Input.is_action_just_pressed("confirm"):
				text_done = false
				bm.start_turn()
