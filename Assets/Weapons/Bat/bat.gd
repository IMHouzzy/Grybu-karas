extends CharacterBody2D
#Can change in the inspector when sword scene is chosen
@export var fire_rate : float
var damage = 40 #base damage

var can_fire = true #Checks if the bullet can be fired
@onready var timer = $Timer
@onready var shot = $Shot
func _ready():
	#Sets the timer 
	timer.wait_time = fire_rate 

func _physics_process(delta):
	#The poiter always rotates in mouse derection
	look_at(get_global_mouse_position())
	# imput fire is left mouse button
	if Input.is_action_pressed("fire ") and can_fire: 
		#disables the hitbox of the sword while in cooldown
		$HitBox/CollisionShape2D.disabled = false
		timer.start()
		can_fire = false
		#shot.play()
	else:
		$HitBox/CollisionShape2D.disabled = true

	# Check if the timer has expired
	if timer.is_stopped() and !can_fire:
		_on_timer_timeout()

func _on_timer_timeout():
	can_fire = true

func _on_hit_box_body_entered(body):
	# Check if the body collided with is not the sword owner (usually the player)
	if body != get_parent():
		if body.is_in_group("Enemy"):
			#Power up damage
			if(Global.increasedDamage == true):
				damage = 60
				body.take_damage(damage)
				print("Dealing damage: ", damage)
			else:
				#None power-up damage
				damage = 40
				body.take_damage(damage)
				print("Dealing damage: ", damage)
