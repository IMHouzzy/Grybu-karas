extends CharacterBody2D
#Can change in the inspector when gun scene is chosen
@export var bullet_speed : int 
@export var fire_rate : float
@export var bullet_life_time : float

var bullet = preload("res://Assets/Weapons/player_bullet.tscn")
var can_fire = true #Checks if the bullet can be fired
@onready var bullet_point = $BulletPoint
@onready var timer = $Timer

func _ready():
	#Sets the timer 
	timer.wait_time = fire_rate 

func _physics_process(delta):
	#The poiter always rotates in mouse derection
	look_at(get_global_mouse_position())
	if global_rotation_degrees >= 90 or global_rotation_degrees <= -90:
		$Sprite2D.flip_v = true
		$Sprite2D.position.y = -7
	else: 
		$Sprite2D.flip_v = false
		$Sprite2D.position.y = 7
	# imput fire is left mouse button
	if Input.is_action_pressed("fire ") and can_fire: 
			create_bullet_instance()
			timer.start()
			can_fire = false
			
	# Check if the timer has expired
	if timer.is_stopped() and !can_fire:
		_on_timer_timeout()

func create_bullet_instance():
	#creates a bullet 
	var bullet_instance = bullet.instantiate()
	#Maches a position of a poiter
	bullet_instance.position = bullet_point.global_position
	#Maches a rotation of a poiter
	bullet_instance.rotation_degrees = rotation_degrees
	#Adds a bullet
	get_tree().get_root().add_child(bullet_instance)
	#Find the velocity for the bullet
	var velocity = Vector2(bullet_speed, 0).rotated(rotation)
	# Set the bullet's velocity
	bullet_instance.set("velocity", velocity)

func _on_timer_timeout():
	can_fire = true
	
