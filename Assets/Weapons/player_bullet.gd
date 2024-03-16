extends Area2D

@export var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	# Move the bullet according to its velocity
	position += velocity * delta
	
func _on_Bullet_body_entered(body):
	# Check if the body collided with is not the bullet's owner (usually the player)
	if body != get_parent():
		# Remove the bullet from the scene
		queue_free()
