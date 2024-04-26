extends CharacterBody2D

@export var ammo: PackedScene

@onready var rayCast = $RayCast2D
@onready var timer = $ReloadTimer

#Variables
var health = 1000
var speed = 50 #Change this if need some tweaking
var player_chase = false
var player = null
var gravity = 700
var direction = Vector2.RIGHT
var currentEntity = position
var maxDistanceRayCast = 300



#Loot enemy drops
var loots = preload("res://Assets/Collectables/Coin.tscn")

func _ready():
	#Change line below so it looks for players not a specific child
	player = get_parent().find_child("CharacterBody2D")


func _physics_process(delta):
	_aim()
	_check_player_collision()
	if player_chase:	#Chases player if in body
		
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
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
	else:
		$Sprite2D.play("Idle")


func _aim():
	if player:
		var direction_to_player = player.global_position - global_position
		if direction_to_player.length() <= maxDistanceRayCast:
			rayCast.target_position = to_local(player.position)
			if direction_to_player.x < 0:
				$Sprite2D.flip_h = true
			else:
				$Sprite2D.flip_h = false
		else:
			rayCast.target_position = Vector2.ZERO
	else:
		rayCast.target_position = Vector2.ZERO

#Checks if player isnt behind a wall
func _check_player_collision():
	if rayCast.get_collider() == player and timer.is_stopped():
		timer.start()
	elif rayCast.get_collider() != player and not timer.is_stopped():
		timer.stop()

#Shoots
func _shoot():
	if player and (player.global_position - global_position).length() <= maxDistanceRayCast:
		var bullet = ammo.instantiate()
		bullet.position = $BulletPoint.global_position #Fix this
		bullet.direction = (rayCast.target_position).normalized()
		get_tree().current_scene.add_child(bullet)
		#$Sprite2D.animation = "Attack"
		#Shoot.play()



func _on_detection_body_entered(body):
	if body.is_in_group("player"):	#Checks if the body is a player if not ignores it
		player = body
		player_chase = true


func _on_detection_body_exited(body):
	if body.is_in_group("player"):	#Checks if the body is a player if not ignores it
		player = null
		player_chase = false

func take_damage(damage):
	health -= damage
	#hitbullet.play()
	#hit.play()
	if health < 0:
		spawn_loot()
		set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact
		queue_free()
		


func _on_stop_detection_body_entered(body):
	if body.is_in_group("player"):	#Checks if the body is a player if not ignores it
		player = null
		player_chase = false


func _on_stop_detection_body_exited(body):
	if body.is_in_group("player"):	#Checks if the body is a player if not ignores it
		player = body
		player_chase = true

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


#Shoots 2 bullets at the same time to deal 2 damage
func _on_reload_timer_timeout():
	_shoot()
	_shoot()
