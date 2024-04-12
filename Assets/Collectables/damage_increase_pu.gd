extends Area2D
#Power-up for increased damage, damage is set in the bullet scene, different for each bullet
#so it can be fine tuned

#Adds functionality for power-up
func _on_body_entered(body):
	if body.is_in_group("player"):
		$Timer.start() #Starts a timer
		print("Timer for increased damage started")
		Global.increasedDamage = true #Increased damage
		set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact

#Removes all the bonuses after time ended
func _on_timer_timeout():
	print("Timer for increased damage stopped")
	Global.increasedDamage = false
	queue_free()
