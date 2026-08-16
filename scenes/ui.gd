extends CanvasLayer

@onready var soul = $Soul

@onready var snd_confirm = $SFX/Confirm
@onready var snd_select = $SFX/Select
@onready var snd_item = $SFX/Item

@onready var quickinfo = $QuickInfo
@onready var submenu_selector = $SubmenuSelector

@onready var textbox = $Textbox
@onready var typewriter = $Textbox/TypeWriterLabel

@onready var item_submenu = $Inventory
@onready var items = [
	$Inventory/Item1,
	$Inventory/Item2,
	$Inventory/Item3,
	$Inventory/Item4,
	$Inventory/Item5,
	$Inventory/Item6,
	$Inventory/Item7,
	$Inventory/Item8
]
@onready var actions = [
	$Inventory/Use,
	$Inventory/Info,
	$Inventory/Drop
]

@onready var stat_submenu = $Statistics
@onready var stat_labels = [
	$Statistics/Name,
	$Statistics/LV,
	$Statistics/HP,
	$Statistics/AT,
	$Statistics/DF,
	$Statistics/EXP,
	$Statistics/NEXT,
	$Statistics/Weapon,
	$Statistics/Armor,
	$Statistics/Gold
]

@onready var cell_submenu = $Cellphone

@onready var btn_item = $SubmenuSelector/Item
@onready var btn_stat = $SubmenuSelector/Stat
@onready var btn_cell = $SubmenuSelector/Cell

@onready var buttons = [btn_item, btn_stat, btn_cell]

var selection := 0
var selected_item := 0
var submenu := 0
# 0 - no submenu
# 1 - inventory
# 2 - inventory action selector
# 3 - statistics
# 4 - cellphone

func _ready():
	update_ui()

func update_ui():
	if not PlayerData.player["cell_unlocked"]:
		$SubmenuSelector/Cell.modulate = Color("000000ff")
		buttons = [btn_item, btn_stat]
	else:
		$SubmenuSelector/Cell.modulate = Color("ffffffff")
	
	if PlayerData.player["items"].size() == 0:
		$SubmenuSelector/Item.modulate = Color("505050ff")
	else:
		$SubmenuSelector/Item.modulate = Color("ffffffff")
	
	$QuickInfo/PlayerName.text = PlayerData.player["name"]
	$QuickInfo/LoveValue.text = str(PlayerData.player["love"])
	$QuickInfo/HPValue.text = "%d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	$QuickInfo/GValue.text = str(PlayerData.player["gold"])
	
	Funcs.debug_print("RECALCULATING STATS\n")
	
	Funcs.debug_print("LV: " + str(PlayerData.player["love"]))
	Funcs.debug_print("HP: " + str(PlayerData.player["hp"]) + "/" + str(PlayerData.player["max_hp"]))
	Funcs.debug_print("AT:")
	Funcs.debug_print("DF:")
	Funcs.debug_print("EXP: " + str(PlayerData.player["exp"]))
	
	if PlayerData.player["love"] == 20:
		Funcs.debug_print("NEXT: 0 (because player LV is 20)")
	else:
		Funcs.debug_print("NEXT: " + str(PlayerData.player["exp"]) + "-" + str(PlayerData.stats[PlayerData.player["love"] + 1][3]) + "=" + str(PlayerData.stats[PlayerData.player["love"] + 1][3] - PlayerData.player["exp"]))
	
	stat_labels[0].text = '"%s"' % PlayerData.player["name"]
	stat_labels[1].text = "LV %d" % PlayerData.player["love"]
	stat_labels[2].text = "HP %d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	stat_labels[3].text = "AT %d (%d)" % [PlayerData.player["base_at"], PlayerData.player["equip_at"]]
	stat_labels[4].text = "DF %d (%d)" % [PlayerData.player["base_df"], PlayerData.player["equip_df"]]
	stat_labels[5].text = "EXP: %d" % PlayerData.player["exp"]
	
	if PlayerData.player["love"] == 20:
		stat_labels[6].text = "NEXT: 0"
	else:
		stat_labels[6].text = "NEXT: %d" % (PlayerData.stats[PlayerData.player["love"] + 1][3] - PlayerData.player["exp"])
		
	stat_labels[7].text = "WEAPON: %s" % PlayerData.get_item_data(PlayerData.player["equipped"][0], "name")
	stat_labels[8].text = "ARMOR: %s" % PlayerData.get_item_data(PlayerData.player["equipped"][1], "name")
	stat_labels[9].text = "GOLD: %d" % PlayerData.player["gold"]
	
	for i in range(items.size()):
		if i < PlayerData.player["items"].size():
			var item_id = PlayerData.player["items"][i]
			
			if str(item_id) == "0":
				items[i].text = ""
			else:
				items[i].text = PlayerData.get_item_data(item_id, "name")
		else:
			items[i].text = ""
	
	if has_node("../Player"):
		var onscr_plrpos = $"../Player".get_global_transform_with_canvas().origin
		if onscr_plrpos.y > 243:
			$QuickInfo.position.y = 322.0
		else:
			$QuickInfo.position.y = 52.0
	

func generate_info_text(sel_item):
	var item_name = PlayerData.get_item_data(PlayerData.player["items"][sel_item], "name")
	var item_info = PlayerData.get_item_data(PlayerData.player["items"][sel_item], "info").replace("[br]", "\n")
	
	var stat_text = ""
	if PlayerData.get_item_data(PlayerData.player["items"][selected_item], "is_weapon"):
		stat_text = "Weapon %d AT" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "equipped_at_boost")
	elif PlayerData.get_item_data(PlayerData.player["items"][selected_item], "is_armor"):
		stat_text = "Armor %d DF" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "equipped_df_boost")
	else:
		if PlayerData.get_item_data(PlayerData.player["items"][sel_item], "full_heal"):
			if PlayerData.get_item_data(PlayerData.player["items"][sel_item], "heal") < 0:
				stat_text = "Some HP"
			else:
				stat_text = "All HP"
		else:
			stat_text = "%d HP" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "heal")

	return '* "%s" - %s\n%s' % [item_name, stat_text, item_info]

func generate_drop_text(sel_item):
	var item_name = PlayerData.get_item_data(PlayerData.player["items"][sel_item], "name")
	
	if item_name == "Abandoned Quiche":
		return "* You leave the Quiche on the\n  ground and tell it you'll\n  be right back."
	
	# literally just a translation of undertale code
	var random = randi_range(0, 18)
	if random == 0:
		return "* You bid a quiet farewell\n  to the %s." % item_name
	elif random == 1:
		return "* You put the %s\n  on the ground and gave it a\n  little pat." % item_name
	elif random == 2:
		return "* You threw the %s\n  on the ground like the\n  piece of trash it is." % item_name
	elif random == 3:
		return "* You abandoned the\n  %s." % item_name
	elif random > 3:
		return "* The %s was\n  thrown away." % item_name

var textbox_done := false
var multidialogue := []
var multipage := false
var cur_page := 0

func do_textbox(text: String):
	PlayerData.global["interact"] = false
	textbox.visible = true
	typewriter.typewrite(text)

func do_multipage_textbox(dialogue: Array, advance: bool):
	if not advance:
		multidialogue = dialogue
		multipage = true
		PlayerData.global["interact"] = false
		textbox.visible = true
		typewriter.typewrite(dialogue[0])
	else:
		if cur_page >= dialogue.size():
			# print("End of textbox")
			textbox_done = false
			multidialogue = []
			multipage = false
			cur_page = 0
			textbox_done = false
			textbox.visible = false
			vis_all(false)
			PlayerData.global["menu_open"] = false
			PlayerData.global["interact"] = true
			selection = 0
			submenu = 0
		else:
			typewriter.typewrite(dialogue[cur_page])

func tekst(text: String):
	PlayerData.global["menu_open"] = false
	PlayerData.recalc_stats(PlayerData.player["love"])
	update_ui()
	soul.visible = false
	textbox.visible = true
	item_submenu.visible = false
	typewriter.typewrite(text)
	do_submenu(0, true)

func select(btn: Node):
	soul.position.x = btn.global_position.x - soul.size.x - 10
	soul.position.y = btn.global_position.y + 9

func vis_all(show:bool):
	if show:
		quickinfo.visible = true
		submenu_selector.visible = true
		soul.visible = true
	else:
		quickinfo.visible = false
		submenu_selector.visible = false
		soul.visible = false

func _on_typewriting_done():
	textbox_done = true

func _input(event):
	if not PlayerData.global["menu_open"] and PlayerData.global["interact"]:
		if event.is_action_pressed("menu"):
			update_ui()
			vis_all(true)
			Funcs.do_sound(snd_select)
			PlayerData.global["interact"] = false
			PlayerData.global["menu_open"] = true
	if PlayerData.global["menu_open"] and not PlayerData.global["interact"]:
		if submenu == 0: # base menu
			if event.is_action_pressed("down"):
				selection = (selection + 1 + buttons.size()) % buttons.size()
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("up"):
				selection = (selection - 1 + buttons.size()) % buttons.size()
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("confirm"):
				do_confirm()
			elif event.is_action_pressed("cancel"):
				PlayerData.global["menu_open"] = false
				PlayerData.global["interact"] = true
				vis_all(false)
				selection = 0
		elif submenu == 1: # ITEM
			if event.is_action_pressed("down"):
				selection = (selection + 1 + PlayerData.player["items"].size()) % PlayerData.player["items"].size()
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("up"):
				selection = (selection - 1 + PlayerData.player["items"].size()) % PlayerData.player["items"].size()
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("confirm"):
				do_confirm()
			if event.is_action_pressed("cancel"):
				select(buttons[0])
				selection = 0
				do_submenu(1, true)
				Funcs.do_sound(snd_select)
		elif submenu == 2: # ITEM submenu
			if event.is_action_pressed("left"):
				selection = (selection - 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("right"):
				selection = (selection + 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif event.is_action_pressed("confirm"):
				do_confirm()
			if event.is_action_pressed("cancel"):
				do_submenu(2, true)
				Funcs.do_sound(snd_select)
		elif submenu == 3: # STAT
			if event.is_action_pressed("cancel"):
				do_submenu(3, true)
				Funcs.do_sound(snd_select)
		
	if submenu == 0:
		for i in range(buttons.size()):
			if i == selection:
				select(buttons[i])
			else:
				pass
	elif submenu == 1:
		for i in range(items.size()):
			if i == selection:
				select(items[i])
			else:
				pass
	elif submenu == 2:
		for i in range(actions.size()):
			if i == selection:
				select(actions[i])
			else:
				pass

func _physics_process(_delta):
	if textbox.visible:
		if typewriter.is_typing():
			if Input.is_action_pressed("cancel"):
				typewriter.skip_typing()
		if textbox_done and Input.is_action_just_pressed("confirm"):
			if not multipage:
				textbox_done = false
				textbox.visible = false
				vis_all(false)
				PlayerData.global["menu_open"] = false
				PlayerData.global["interact"] = true
				selection = 0
				submenu = 0
			else:
				textbox_done = false
				cur_page += 1
				do_multipage_textbox(multidialogue, true)

func do_confirm(): # TODO: finish
	if submenu == 0:
		if selection == 0: # item
			if PlayerData.player["items"].size() > 0:
				Funcs.do_sound(snd_confirm)
				do_submenu(1, false)
		elif selection == 1: # stat
			Funcs.do_sound(snd_confirm)
			do_submenu(3, false)
		elif selection == 2: # cell
			Funcs.do_sound(snd_confirm)
			do_submenu(4, false)
	elif submenu == 1:
		Funcs.do_sound(snd_confirm)
		selected_item = selection
		do_submenu(2, false)
	elif submenu == 2:
		if selection == 0: # use
			if selected_item >= 0 and selected_item < PlayerData.player["items"].size():
				var item_id = PlayerData.player["items"][selected_item]
				
				var is_weapon = PlayerData.get_item_data(item_id, "is_weapon")
				var is_armor = PlayerData.get_item_data(item_id, "is_armor")
				var equippable = PlayerData.get_item_data(item_id, "equippable")
				var consumable = PlayerData.get_item_data(item_id, "consumable")
				
				var heal = PlayerData.get_item_data(item_id, "heal")
				var full_heal = PlayerData.get_item_data(item_id, "full_heal")
				
				var at_boost = PlayerData.get_item_data(item_id, "at_boost")
				var df_boost = PlayerData.get_item_data(item_id, "df_boost")
				
				var message = "* You used the item."
				
				if is_weapon:
					if equippable:
						var old_weapon = PlayerData.player["equipped"][0]
						
						PlayerData.player["equipped"][0] = item_id
						
						if str(old_weapon) != "0" and str(old_weapon) != "":
							PlayerData.player["items"][selected_item] = old_weapon
						else:
							PlayerData.player["items"].pop_at(selected_item)
							
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						Funcs.do_sound(snd_item)
						tekst(message)
					else:
						if consumable:
							var on_use_text = PlayerData.get_item_data(item_id, "on_use")
							if full_heal:
								PlayerData.player["hp"] = PlayerData.player["max_hp"]
								message = "%s\n* Your HP was maxed out." % on_use_text
							else:
								var old_hp = PlayerData.player["hp"]
								PlayerData.player["hp"] = min(PlayerData.player["hp"] + heal, PlayerData.player["max_hp"])
								if PlayerData.player["hp"] == PlayerData.player["max_hp"]:
									message = "%s\n* Your HP was maxed out." % on_use_text
								else:
									message = "%s\n* You healed %d HP." % [on_use_text, PlayerData.player["hp"] - old_hp]
							
							PlayerData.player["items"].pop_at(selected_item)
							tekst(message)
							update_ui()
						else:
							message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
							tekst(message)
				
				elif is_armor:
					if equippable:
						var old_armor = PlayerData.player["equipped"][1]
						
						PlayerData.player["equipped"][1] = item_id
						
						if str(old_armor) != "0" and str(old_armor) != "":
							PlayerData.player["items"][selected_item] = old_armor
						else:
							PlayerData.player["items"].pop_at(selected_item)
							
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						Funcs.do_sound(snd_item)
						tekst(message)
					else:
						if consumable:
							var on_use_text = PlayerData.get_item_data(item_id, "on_use")
							if full_heal:
								PlayerData.player["hp"] = PlayerData.player["max_hp"]
								message = "%s\n* Your HP was maxed out." % on_use_text
							else:
								var old_hp = PlayerData.player["hp"]
								PlayerData.player["hp"] = min(PlayerData.player["hp"] + heal, PlayerData.player["max_hp"])
								if PlayerData.player["hp"] == PlayerData.player["max_hp"]:
									message = "%s\n* Your HP was maxed out." % on_use_text
								else:
									message = "%s\n* You healed %d HP." % [on_use_text, PlayerData.player["hp"] - old_hp]
							
							PlayerData.player["items"].pop_at(selected_item)
							tekst(message)
							update_ui()
						else:
							message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
							tekst(message)
				else:
					var on_use_text = PlayerData.get_item_data(item_id, "on_use")
					if full_heal:
						PlayerData.player["hp"] = PlayerData.player["max_hp"]
						message = "%s\n* Your HP was maxed out." % on_use_text
					else:
						var old_hp = PlayerData.player["hp"]
						PlayerData.player["hp"] = min(PlayerData.player["hp"] + heal, PlayerData.player["max_hp"])
						if PlayerData.player["hp"] == PlayerData.player["max_hp"]:
							message = "%s\n* Your HP was maxed out." % on_use_text
						else:
							message = "%s\n* You healed %d HP." % [on_use_text, PlayerData.player["hp"] - old_hp]
					
					PlayerData.player["items"].pop_at(selected_item)
					tekst(message)
					update_ui()
					Funcs.do_sound($SFX/Swallow)
					await get_tree().create_timer(0.35).timeout
					Funcs.do_sound($SFX/Heal)
					
		if selection == 1: # info
			tekst(generate_info_text(selected_item))
		if selection == 2: # drop
			tekst(generate_drop_text(selected_item))
			PlayerData.player["items"].pop_at(selected_item)

func do_submenu(x:int, do_hide:bool):
	if x == 0:
		pass
	elif x == 1:
		if not do_hide:
			item_submenu.visible = true
			submenu = 1
		else:
			item_submenu.visible = false
			submenu = 0
	elif x == 2:
		if not do_hide:
			submenu = 2
			selection = 0
		else:
			submenu = 1
	elif x == 3:
		if not do_hide:
			update_ui()
			soul.visible = false
			stat_submenu.visible = true
			submenu = 3
		else:
			soul.visible = true
			stat_submenu.visible = false
			submenu = 0
