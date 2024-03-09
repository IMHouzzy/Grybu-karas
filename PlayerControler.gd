extends CharacterBody2D

const SPEED = 600.0 #Character speed
const JUMP_VELOCITY = -550.0 #Jump hight
const  DOUBLE_JUMP_VELOCITY = -400 #Second jump hight

var jumps_made = 0 #jump counter
var max_jumps = 2 # max jumps that character can make (galima keisti jeigu reikia)
@onready var sprite_2d = $Sprite2D #calling the picture (sprite of a character)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#States of a player
	var is_falling = velocity.y > 0.0 and not is_on_floor() #Triggers when palyer is in the air and velocity is 0
	var is_running = is_on_floor() and not is_zero_approx(velocity.x) #Triggers when palyer is on the ground and is moving 
	var is_idling = is_on_floor() and is_zero_approx(velocity.x) #Triggers when palyer is on the ground and is not moving 
	var is_jumping = Input.is_action_pressed("jump") and is_on_floor() #Triggers when palyer is on the ground and the jump button is pressed (W or up arrow)
	var is_double_jumping = Input.is_action_pressed("jump") and is_falling #Triggers when palyer is in a falling state and the jump button is pressed
	
	if is_jumping:
		velocity.y = JUMP_VELOCITY
		jumps_made += 1
	elif is_double_jumping:
		jumps_made += 1
		if jumps_made <= max_jumps:
			velocity.y = DOUBLE_JUMP_VELOCITY
	elif is_running or is_idling:
		jumps_made = 0

	move_and_slide()
	#Flips the sprite when the palyer is going to the left
	var isLeft= velocity.x < 0
	sprite_2d.flip_h = isLeft
