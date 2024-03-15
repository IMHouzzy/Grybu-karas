extends Area2D

#If coin collected by player add 1 to coin collection
func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.collectedCurrency()
		print(Global.currency) #Used for testing
		queue_free()
