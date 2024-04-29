extends Node

var currency: int
var maxHealth = 3 #Global max health
var currentHealth = maxHealth #Global current Health
var increasedHealth: bool = false
var increasedCapacity: bool = false
var increasedDamage: bool = false
var invincibility: bool = false

#guns
var has_pistol = false
var has_uzi = false
var has_sword = false
var has_bat = false
var has_axe = false
#If coin collected add 1
func collectedCurrency():
	currency += 1
