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

var more_text := false

func _ready():
	update_ui()

func update_ui():
	if not PlayerData.player["cell_unlocked"]:
		$SubmenuSelector/Cell.modulate = Color("#7f7f7fff")
	else:
		$SubmenuSelector/Cell.modulate = Color("ffffffff")
	
	$QuickInfo/PlayerName.text = PlayerData.player["name"]
	$QuickInfo/LoveValue.text = str(PlayerData.player["love"])
	$QuickInfo/HPValue.text = "%d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	$QuickInfo/GValue.text = str(PlayerData.player["gold"])
	
	stat_labels[0].text = '"%s"' % PlayerData.player["name"]
	stat_labels[1].text = "LV %d" % PlayerData.player["love"]
	stat_labels[2].text = "HP %d / %d" % [PlayerData.player["hp"], PlayerData.player["max_hp"]]
	stat_labels[3].text = "AT %d (%d)" % [PlayerData.player["base_at"], PlayerData.player["equip_at"]]
	stat_labels[4].text = "DF %d (%d)" % [PlayerData.player["base_df"], PlayerData.player["equip_df"]]
	stat_labels[5].text = "EXP: %d" % PlayerData.player["exp"]
	stat_labels[6].text = "NEXT: %d" % 10 # todo: fix
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

func generate_info_text(sel_item):
	# 1. Get the item ID and the full resource data
	var item_name = PlayerData.get_item_data(PlayerData.player["items"][sel_item], "name")
	var item_info = PlayerData.get_item_data(PlayerData.player["items"][sel_item], "info")
	
	# 2. Build the "Stat" string based on the item type
	var stat_text = ""
	if PlayerData.get_item_data(PlayerData.player["items"][selected_item], "is_weapon"):
		stat_text = "Weapon %d AT" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "equipped_at_boost")
	elif PlayerData.get_item_data(PlayerData.player["items"][selected_item], "is_armor"):
		stat_text = "Armor %d DF" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "equipped_df_boost")
	else:
		stat_text = "Heals %d HP" % PlayerData.get_item_data(PlayerData.player["items"][selected_item], "heal")

	return '* "%s" - %s\n%s' % [item_name, stat_text, item_info]

func tekst(text:String):
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
		visible = true
	else:
		quickinfo.visible = false
		submenu_selector.visible = false
		soul.visible = false
		visible = false

func _physics_process(_delta):
	# textbox test
	if textbox.visible:
		if typewriter.is_typing():
			if Input.is_action_just_pressed("cancel"):
				typewriter.skip_typing()
		if not typewriter.is_typing() and Input.is_action_just_pressed("confirm"):
			if not more_text:
				textbox.visible = false
				vis_all(false)
				PlayerData.global["menu_open"] = false
				PlayerData.global["interact"] = true
				selection = 0
				submenu = 0
			else:
				pass # god this will be so hard
		
	if PlayerData.global["menu_open"] and not PlayerData.global["interact"]:
		if submenu == 0:
			if Input.is_action_just_pressed("down"):
				selection = (selection + 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("up"):
				selection = (selection - 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("confirm"):
				do_confirm()
			elif Input.is_action_just_pressed("cancel"):
				PlayerData.global["menu_open"] = false
				PlayerData.global["interact"] = true
				vis_all(false)
				selection = 0
		elif submenu == 1:
			if Input.is_action_just_pressed("down"):
				selection = (selection + 1 + 8) % 8
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("up"):
				selection = (selection - 1 + 8) % 8
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("confirm"):
				do_confirm()
			if Input.is_action_just_pressed("cancel"):
				do_submenu(1, true)
		elif submenu == 2:
			if Input.is_action_just_pressed("left"):
				selection = (selection - 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("right"):
				selection = (selection + 1 + 3) % 3
				Funcs.do_sound(snd_select)
			elif Input.is_action_just_pressed("confirm"):
				do_confirm()
			if Input.is_action_just_pressed("cancel"):
				do_submenu(2, true)
		elif submenu == 3:
			if Input.is_action_just_pressed("cancel"):
				do_submenu(3, true)
		
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

func do_confirm(): # todo: finish
	if submenu == 0:
		if selection == 0: # item
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
				# Get the Item ID first to keep code clean
				var item_id = PlayerData.player["items"][selected_item]
				
				var is_weapon = PlayerData.get_item_data(item_id, "is_weapon")
				var is_armor = PlayerData.get_item_data(item_id, "is_armor")
				var equippable =PlayerData.get_item_data(item_id, "equippable")
				
				var heal = PlayerData.get_item_data(item_id, "heal")
				var full_heal = PlayerData.get_item_data(item_id, "full_heal")
				
				var at_boost = PlayerData.get_item_data(item_id, "at_boost")
				var df_boost = PlayerData.get_item_data(item_id, "df_boost")
				
				var message = "* You used the item."
				
				if is_weapon:
					if equippable:
						# Grab the raw value (could be the int 0, could be a String "sword")
						var old_weapon = PlayerData.player["equipped"][0]
						
						# Equip the new weapon
						PlayerData.player["equipped"][0] = item_id
						
						# Safely compare by forcing the check to look at everything as text
						if str(old_weapon) != "0" and str(old_weapon) != "":
							# We had a weapon, put it in the inventory slot
							PlayerData.player["items"][selected_item] = old_weapon
						else:
							# We were unarmed, just remove the newly equipped item from inventory
							PlayerData.player["items"].pop_at(selected_item)
							
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						Funcs.do_sound(snd_item)
						tekst(message)
					else:
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						tekst(message)
				
				elif is_armor:
					if equippable:
						# Grab the raw value
						var old_armor = PlayerData.player["equipped"][1]
						
						# Equip the new armor
						PlayerData.player["equipped"][1] = item_id
						
						# Safely compare
						if str(old_armor) != "0" and str(old_armor) != "":
							PlayerData.player["items"][selected_item] = old_armor
						else:
							PlayerData.player["items"].pop_at(selected_item)
							
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						Funcs.do_sound(snd_item)
						tekst(message)
					else:
						message = PlayerData.get_item_data(item_id, "on_use").c_unescape()
						tekst(message)
				
				elif is_armor:
					var old_armor = int(PlayerData.player["equipped"][1])
					PlayerData.player["equipped"][1] = item_id
					
					if old_armor != 0:
						PlayerData.player["items"][selected_item] = old_armor
					else:
						PlayerData.player["items"].pop_at(selected_item)
						
					message = "* You equipped the %s." % PlayerData.get_item_data(item_id, "name")
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
					
		if selection == 1: # info
			tekst(generate_info_text(selected_item))
		if selection == 2: # drop
			pass

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
