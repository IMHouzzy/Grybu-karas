extends Node

var currency: int
var maxHealth = 3 #Global max health
var currentHealth = maxHealth #Global current Health
var increasedHealth: bool = false
var increasedCapacity: bool = false
#If coin collected add 1
func collectedCurrency():
	currency += 1

