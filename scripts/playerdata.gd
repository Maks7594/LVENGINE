extends Node

var player = {
	"name": "Chara",
	"love": 1,
	"exp": 0,
	
	"hp": 20,
	"max_hp": 20,
	
	"base_at": 0,
	"base_df": 0,
	"equip_at": 0,
	"equip_df": 0,
	"at_boost": 0,
	"df_boost": 0,
	"total_at": 0,
	"total_df": 0,
	
	"gold": 0,
	
	"items": [
		"proton_slicer",
		"netherite_chestplate",
		"tough_glove",
		"faded_ribbon",
		"butterscotch_pie",
		"snail_pie",
		"monster_candy",
		"monster_candy"
	],
	
	"equipped": [
		"stick",
		"bandage"
	],
	
	"cell_unlocked": false
}

var stats = {
	# love: [max hp, at, df, total exp]
	0: [20, 0, 0, -10],
	1: [20, 0, 0, 0],
	2: [24, 2, 0, 10],
	3: [28, 4, 0, 30],
	4: [32, 6, 0, 70],
	5: [36, 8, 1, 120],
	6: [40, 10, 1, 200],
	7: [44, 12, 1, 300],
	8: [48, 14, 1, 500],
	9: [52, 16, 2, 800],
	10: [56, 18, 2, 1200],
	11: [60, 20, 2, 1700],
	12: [64, 22, 2, 2500],
	13: [68, 24, 3, 3500],
	14: [72, 26, 3, 5000],
	15: [76, 28, 3, 7000],
	16: [80, 30, 3, 10000],
	17: [84, 32, 4, 15000],
	18: [88, 34, 4, 25000],
	19: [92, 36, 4, 50000],
	20: [99, 38, 4, 99999]
}

var global = {
	"interact": true,
	"menu_open": false,
	"in_battle": false,
	"cam_active": true
}

func get_item_data(item: String, data: String):
	var path = "res://data/items/%s.tres" % item
	
	if ResourceLoader.exists(path):
		var item_tres = load(path) as Item
		if item_tres:
			return item_tres.get(data)
	
	push_error("Failed to get data %s of item %s!" % [data, item])
	return null

func recalc_stats(love: int):
	var old_love = player["love"]
	
	player["max_hp"] = stats[love][0]
	
	player["base_at"] = stats[love][1]
	player["base_df"] = stats[love][2]
	
	player["equip_at"] = get_item_data(player["equipped"][0], "equipped_at_boost")
	player["equip_df"] = get_item_data(player["equipped"][1], "equipped_df_boost")
	
	player["total_at"] = player["base_at"] + player["equip_at"] + player["at_boost"]
	player["total_df"] = player["base_df"] + player["equip_df"] + player["df_boost"]
	
	if player["love"] >= 20:
		return
	var next_lvl_exp = stats[player["love"] + 1][3]
	if player["exp"] >= next_lvl_exp:
		player["love"] += 1
		recalc_stats(player["love"])

func DEBUG_set_lv(love: int):
	PlayerData.player["love"] = love
	PlayerData.player["exp"] = stats[love][3]
	recalc_stats(player["love"])
