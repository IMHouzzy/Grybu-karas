extends CharacterBody2D

@onready var ledgeCheckLeft: = $LedgeCheckLeft
@onready var ledgeCheckRight: = $LedgeCheckRight
var loots = preload("res://Assets/Collectables/Coin.tscn")
#Variables
var health = 600
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

#Handles the taking damage logic
func take_damage(damage):
	health -= damage
	if health < 0:
		queue_free()
		spawn_loot()


#Spawns loot
func spawn_loot():
	var random_ammount = randf_range(2,4)
	var loot_radius = 20
	for i in range(random_ammount):
		var loot_instance = loots.instantiate()
		loot_instance.position = find_empty_position(loot_radius)
		get_tree().get_root().add_child(loot_instance)




#Handles spawning logic, but there is a problem with spawning inside walls
func find_empty_position(radius):
	var position = Vector2.ZERO
	var tries = 0
	while tries < 10:
		position.x = global_position.x + randf_range(-radius, radius)
		position.y = global_position.y + randf_range(-radius, radius)
		
		var overlapping = false
		for child in get_tree().get_root().get_children():
			if child != self and child.is_in_group("Collectible"):
				var distance_squared = child.global_position.distance_squared_to(position)
				if distance_squared < radius * radius:
					overlapping = true
					break
			
		if not overlapping:
			return position
		
		tries += 1
	return position
