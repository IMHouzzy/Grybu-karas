extends CharacterBody2D

@onready var ledgeCheckLeft: = $LedgeCheckLeft
@onready var ledgeCheckRight: = $LedgeCheckRight

#Variables
var speed = 175 #Change this if need some tweaking
var player_chase = false
var player = null
var gravity = 700
var direction = Vector2.RIGHT

func _physics_process(delta):
	#Sees if there is a ledge left or right
	var found_ledge = not ledgeCheckLeft.is_colliding() or not ledgeCheckRight.is_colliding()
	
	if player_chase:	#Chases player if in body
		if found_ledge:	#Makes the enemy stop and not chase further if there is a ledge
			#Problem with this is when he hits ledge, he goes backwards, but might be cool
			direction *= -1 #This changes the direction the enemy goes, making him go back possible bug
		
		#Calculates the speed
		#Calculate the direction of the enemies movement
		var target_direction = (player.global_position - global_position).normalized()
		
		#Set the velocity at a constant speed
		velocity = target_direction * speed * direction
		velocity.y += gravity #Falling
		
		$Sprite2D.play("Walking")
		move_and_slide()
		
		#Flip the animation if going left
		if(player.position.x -position.x) < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		$Sprite2D.play("Idle")
	

# When detection area entered chase player
func _on_detection_body_entered(body):
	if body.is_in_group("player"):	#Checks if the body is a player if not ignores it
		player = body
		player_chase = true

#When player is outside of detection area stop chasing
func _on_detection_body_exited(body):
	player = null
	player_chase = false
