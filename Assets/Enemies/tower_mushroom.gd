extends Node2D

@onready var rayCast = $RayCast2D
@onready var timer = $ReloadTimer
@export var ammo: PackedScene

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
