extends Resource
## An enemy. In battle, deals damage.
class_name Enemy

@export_group("Information")
@export var name := "Test Enemy"
@export var check := "It's a dev cube."

@export var max_hp := 20
@export var attack := 5
@export var defense := 5
@export var gold_on_win := 10
@export var exp_on_win := 20

@export_group("Acts")
@export var acts := 2
@export var act1_name := "Check"
@export var act1_mercy := 0
@export var act1_message := "* %s - ATK %d DEF %d\n* %s" % [name, attack, defense, check]

@export var act2_name := "Mercy"
@export var act2_mercy := 100
@export var act2_message := "* Made the enemy sparable!"
