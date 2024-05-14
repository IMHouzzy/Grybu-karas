extends Area2D

@export var velocity: Vector2 = Vector2.ZERO
var damage = 100 #base damage
func _physics_process(delta):
	# Move the bullet according to its velocity
	position += velocity * delta

func _on_Bullet_body_entered(body):
	# Check if the body collided with is not the bullet's owner (usually the player)
	if body != get_parent():
		queue_free() #Remove bullet if you hit a ground
		if body.is_in_group("Enemy"):
			#Power up damage
			if(Global.increasedDamage == true):
				damage = 150
				body.take_damage(damage)
				print("Dealing damage: ", damage)
			else:
				#None power-up damage
				damage = 100
				body.take_damage(damage)
				print("Dealing damage: ", damage)
			# Remove the bullet from the scene
			queue_free()
