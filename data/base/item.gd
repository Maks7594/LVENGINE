extends Resource
## An item.
## It can heal HP, boost attack or defense or be used as a weapon or armor.
class_name Item

@export_group("Information")
## The translation string of the item.
@export var name := "Test Item"
## Description of the item (displayed via INFO in inventory)
@export var info := "* A square box with dev textures. Heals 20HP."
## Message upon using the item (via USE)
## Will also show when item is armory and equippable is set to false.
@export var on_use := "* You used the Test Item."

@export_group("Effects")
## Can the item be consumed?
@export var consumable := true
## How many HP does the item heal?
@export var heal := 0
## Does the item fully heal the player?
## For example, setting heal to -1 with this set to true will heal max hp - 1.
@export var full_heal := true
## How much AT does this item give when consumed?
@export var at_boost := 0
## How much DF does this item give when consumed?
@export var df_boost := 0
## How much AT does this item give when equipped?
@export var equipped_at_boost := 0
## How much AT does this item give when equipped?
@export var equipped_df_boost := 0

@export_group("Equipment")
## Is this item equippable? This is set to false for items like Stick and Bandage.
@export var equippable := false
## Can this item be equipped as a weapon? Overrides is_armor if this is set.
@export var is_weapon := false
## Can this item be equipped as armor?
@export var is_armor := false
