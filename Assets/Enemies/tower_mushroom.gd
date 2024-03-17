extends Node2D

@onready var rayCast = $RayCast2D
@onready var timer = $ReloadTimer
@export var ammo: PackedScene
var loots = preload("res://Assets/Collectables/Diamond.tscn")

var health = 100
var player 
var currentEntity = position
var maxDistanceRayCast = 300
#Waits for player to load
func _ready():
	#Change line below so it looks for players not a specific child
	player = get_parent().find_child("CharacterBody2D")

#Handles all the logic of shooting and player location 
func _physics_process(delta):
	_aim()
	_check_player_collision()

#Shoots bullet towards player
func _aim():
	var direction_to_player = player.global_position - global_position
	if direction_to_player.length() <= maxDistanceRayCast:
		rayCast.target_position = to_local(player.position)
	else:
		rayCast.target_position = Vector2.ZERO

#Checks if player isnt behind a wall
func _check_player_collision():
	if rayCast.get_collider() == player and timer.is_stopped():
		timer.start()
	elif rayCast.get_collider() != player and not timer.is_stopped():
		timer.stop()

#Shoots when timer resets
func _on_reload_timer_timeout():
	_shoot()

#Shoots bullet
func _shoot():
	var bullet = ammo.instantiate()
	bullet.position = position
	bullet.direction = (rayCast.target_position).normalized()
	get_tree().current_scene.add_child(bullet)

#Take damage function
func take_damage(damage):
	health -= damage
	if health < 0:
		spawn_loot()
		queue_free()

#Spawns loot 
func spawn_loot():
	var random_ammount = randf_range(1,2)
	var loot_radius = 10 #Change this value for some enemies
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
