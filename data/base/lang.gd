extends Node

var current_locale = {}

func change_locale(locale: String):
	match locale:
		"en_us":
			current_locale = en_us
		"pl_pl":
			current_locale = pl_pl
		_: # fallback
			current_locale = en_us

var en_us = {
	"str_quickinfo_item": "ITEM",
	"str_quickinfo_stat": "STAT",
	"str_quickinfo_cell": "CELL",
	"str_itemsub_use": "USE",
	"str_itemsub_info": "INFO",
	"str_itemsub_drop": "DROP",
	"str_statsub_lv": "LV",
	"str_statsub_hp": "HP",
	"str_statsub_at": "AT",
	"str_statsub_df": "DF",
	"str_statsub_exp": "EXP",
	"str_statsub_next": "NEXT",
	"str_statsub_weapon": "WEAPON",
	"str_statsub_armor": "ARMOR",
	"str_statsub_gold": "GOLD",
	"str_statsub_kills": "KILLS",
	"itm_proton_slicer": "Proton Slicer",
	"itm_neth_chest": "Netherite Chestplate",
	"itm_tough_glove": "Tough Glove",
	"itm_faded_ribbon": "Faded Ribbon",
	"itm_stick": "Stick",
	"itm_bandage": "Bandage",
	"itm_monster_candy": "Monster Candy"
}
	
var pl_pl = {
	"str_quickinfo_item" : "RZECZ",
	"str_quickinfo_stat" : "STATY",
	"str_quickinfo_cell" : "TELE",
	"str_itemsub_use" : "UZYJ",
	"str_itemsub_info" : "INFO",
	"str_itemsub_drop" : "RZUC",
	
	"str_statsub_lv" : "POZ",
	"str_statsub_hp" : "PZ",
	"str_statsub_at" : "AT",
	"str_statsub_df" : "OB",
	"str_statsub_exp" : "PD",
	"str_statsub_next" : "NAST",
	"str_statsub_weapon" : "BRON",
	"str_statsub_armor" : "ZBROJA",
	"str_statsub_gold" : "KASA",
	"str_statsub_kills" : "KILLS",
	
	"itm_proton_slicer" : "Przecinacz protonów",
	"itm_neth_chest" : "Netherite Chestplate",
	"itm_tough_glove" : "Tough Glove",
	"itm_faded_ribbon" : "Faded Ribbon",
	"itm_stick" : "Patyk",
	"itm_bandage" : "Bandaz",
	"itm_monster_candy" : "Monster Candy"
}
