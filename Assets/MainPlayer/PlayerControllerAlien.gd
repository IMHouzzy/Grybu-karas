extends CharacterBody2D

var SPEED = 300.0 #Character speed
var JUMP_VELOCITY = -700 #Jump hight
var  DOUBLE_JUMP_VELOCITY = -600 #Second jump hight


var jumps_made = 0 #jump counter
var max_jumps = 2 # max jumps that character can make (galima keisti jeigu reikia)
@onready var sprite_2d = $Sprite2D #calling the picture (sprite of a character)
@onready var RightCheckAbove =$RightCheckAbove #Check if there is an objec above player head on the right on the colider
@onready var LeftCheckAbove =$LeftCheckAbove #Check if there is an objec above player head on the left on the colider
#@onready var maxHealth = Global.maxHealth
#@onready var currentHealth = Global.currentHealth
var heartsContainer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	#Animations
	#Checks if duck button is pressed and if the player is under the object
	if Input.is_action_pressed("crouch") or RightCheckAbove.is_colliding() or LeftCheckAbove.is_colliding():
		if not is_zero_approx(velocity.x):
			sprite_2d.animation = "CrouchWalking"
		else:
			sprite_2d.animation = "Crouching"
		#Swiches to crouching collider
		_crouchingcollison()
	elif Input.is_action_pressed("jump") and  is_on_floor():
		sprite_2d.animation = "jumping"
		#Swiches back to normal collider
		_normalcollison()
	elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and (velocity.x>1 || velocity.x<-1) and is_on_floor():
		sprite_2d.animation = "Running"
		#Swiches back to normal collider
		_normalcollison()
	elif is_on_floor():
		sprite_2d.animation = "idle"
		#Swiches back to normal collider
		_normalcollison()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		
	#States of a player
	var is_falling = velocity.y > 0.0 and not is_on_floor() #Triggers when palyer is in the air and velocity is 0
	var is_running = is_on_floor() and not is_zero_approx(velocity.x) #Triggers when palyer is on the ground and is moving 
	var is_idling = is_on_floor() and is_zero_approx(velocity.x) #Triggers when palyer is on the ground and is not moving 
	var is_jumping = Input.is_action_pressed("jump") and is_on_floor() #Triggers when palyer is on the ground and the jump button is pressed (W or up arrow)
	var is_double_jumping = Input.is_action_pressed("jump") and is_falling #Triggers when palyer is in a falling state and the jump button is pressed
	var is_ducking = Input.is_action_pressed("crouch") and is_on_floor() #Triggers when palyer is in a falling state and the jump button is pressed
	
	if is_jumping:
		velocity.y = JUMP_VELOCITY
		jumps_made += 1
	elif is_double_jumping:
		jumps_made += 1
		if jumps_made <= max_jumps:
			velocity.y = DOUBLE_JUMP_VELOCITY
	elif is_running or is_idling or is_ducking:
		jumps_made = 0
	
	move_and_slide()
	
	#Flips the sprite when the palyer is going to the left
	if Input.is_action_pressed("move_left"):
		sprite_2d.flip_h = true
	elif Input.is_action_pressed("move_right"):
		sprite_2d.flip_h = false
		
	#Setting for normal collision
	
	#Adds back 1 heart when picked up
	applyHealthIncreasePowerUp()

func _normalcollison():
	$HurtBox/HitBoxNormal.disabled = false
	$HurtBox/HitBoxCrouch.disabled = true
	$NormalColision.disabled = false
	$CrouchingColision.disabled = true
	SPEED = 300.0
	JUMP_VELOCITY = -700
	DOUBLE_JUMP_VELOCITY = -600
	#Setting for crouching collision
func _crouchingcollison():
	$HurtBox/HitBoxNormal.disabled = true
	$HurtBox/HitBoxCrouch.disabled = false
	$NormalColision.disabled = true
	$CrouchingColision.disabled = false
	SPEED = 150
	JUMP_VELOCITY = -500
	DOUBLE_JUMP_VELOCITY = -400


#Sets up health
func _ready():
	heartsContainer = $heartsContainer
	heartsContainer.setMaxHearts(Global.maxHealth)
	updateHealthGUI()

#Updates the health container to display correct hearts
func updateHealthGUI():
	heartsContainer.updateHearts(Global.currentHealth)

#Handles the damage taking logic
func healthDamage(takenDamage: int):
	Global.currentHealth -= 1
	print(Global.currentHealth)
	updateHealthGUI()
	if Global.currentHealth <= 0:
		print("dead") #Change to quee free when respawn allowed

#Takes damage when hit by bullet
func _on_hurt_box_area_entered(area):
	var takenDamage
	if area.is_in_group("EnemyBullet"):
		takenDamage = 1
		healthDamage(takenDamage)

#Checks global variable if health power-up was picked up
func applyHealthIncreasePowerUp():
	if Global.increasedHealth == true:
		updateHealthGUI()
		Global.increasedHealth = false
