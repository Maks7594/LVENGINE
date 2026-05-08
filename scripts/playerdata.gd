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
	"total_at": "base_at" + "equip_at" + "at_boost",
	"total_df": "base_def" + "equip_df" + "df_boost",
	
	"gold": 0,
	
	"items": [
		"proton_slicer",
		"netherite_chestplate",
		"tough_glove",
		"faded_ribbon",
		"monster_candy",
		"monster_candy",
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
	#lv: [max hp, at, df]
	1: [20, 0, 0],
	2: [24, 2, 0],
	3: [28, 4, 0],
	4: [32, 6, 0],
	5: [36, 8, 1],
	6: [40, 10, 1],
	7: [44, 12, 1],
	8: [48, 14, 1],
	9: [52, 16, 2],
	10: [56, 18, 2],
	11: [60, 20, 2],
	12: [64, 22, 2],
	13: [68, 24, 3],
	14: [72, 26, 3],
	15: [76, 28, 3],
	16: [80, 30, 3],
	17: [84, 32, 4],
	18: [88, 34, 4],
	19: [92, 36, 4],
	20: [99, 38, 4]
}

var camLimit = Vector2()

func get_item_data(item: String, data: String):
	var path = "res://data/items/%s.tres" % item
	
	if FileAccess.file_exists(path):
		var item_tres = load(path) as Item
		if item_tres:
			return item_tres.get(data)
	
	push_error("Failed to get data %s of item %s!" % [data, item])
	return "Unknown"

func recalc_stats(love:int):
	player["love"] = love
	
	var stats = get_stats(love)
	
	player["max_hp"] = stats[0]
	
	player["base_at"] = stats[1]
	player["base_df"] = stats[2]
	
	player["equip_at"] = get_item_data(player["equipped"][0], "equipped_at_boost")
	player["equip_df"] = get_item_data(player["equipped"][1], "equipped_df_boost")
	
	player["total_at"] = player["base_at"] + player["equip_at"] + player["at_boost"]
	player["total_df"] = player["base_df"] + player["equip_df"] + player["at_boost"]

func get_stats(love:int):
	var lv = clamp(love, 1, 20)
	
	var hp = stats[love][0]
	var at = stats[love][1]
	var df = stats[love][2]
	
	return [hp, at, df]

var global = {
	"interact": true,
	"menu_open": false,
}
