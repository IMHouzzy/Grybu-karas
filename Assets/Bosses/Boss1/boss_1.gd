extends CharacterBody2D

enum BossState {
	SHOOT, DASH, IDLE
}
var current_state = BossState.IDLE
@export var ammo: PackedScene

var playerBool : bool = false

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("CharacterBody2D")
@onready var sprite = $AnimatedSprite2D
@onready var bar = $ProgressBar
@onready var ShootTimer = $ShootTimer

var health: = 2:
	set(value):
		health = value
		bar.value = value
		
var direction = Vector2.RIGHT
var speed = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	direction = (player.global_position - global_position).normalized()
	ray_cast.target_position = direction * 300 # range of the ray cast

func _physics_process(delta):

	if(player.position.x -position.x) < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if playerBool:
		velocity = direction * speed
	# Add the gravity.
	velocity.y += gravity #Falling

	move_and_slide()
	match current_state:
		BossState.SHOOT:
			print("hello")
			shoot()
	

func _input(event):
	if event.is_action_pressed("test"):
		health-=1

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		playerBool = true
func shoot():
	if playerBool:
		var bullet = preload("res://Assets/Bosses/Boss1/bossbullet.tscn").instantiate()
		bullet.position = global_position
		bullet.direction = (player.global_position - global_position).normalized()
		get_tree().current_scene.call_deferred("add_child",bullet)


func _on_shoot_timer_timeout():
	current_state = BossState.SHOOT

