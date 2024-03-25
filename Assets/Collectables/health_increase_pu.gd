extends Area2D
@onready var sprite = $Sprite2D

#When the body is enetered give the player 1 health
func _on_body_entered(body):
	if body.is_in_group("player"):
		if Global.currentHealth < Global.maxHealth: #If the current health is less than max give 1 health
			print("")
			print("add 1 health")			
			print("Max Health: ", str(Global.maxHealth))
			print("Current health: ", str(Global.currentHealth))
			Global.currentHealth += 1
			Global.increasedHealth = true
			queue_free()
		else:
			print("")
			print("Hhahah dont get it")
			print("Max Health: ", str(Global.maxHealth))
			print("Current health: ", str(Global.currentHealth))
			queue_free()
