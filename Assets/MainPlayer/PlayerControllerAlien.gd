extends CharacterBody2D

#Enemy debufs
var speedDebuf: bool = false
var debufSpeed = 150


var SPEED = 300.0 #Character speed
var JUMP_VELOCITY = -700 #Jump hight
var  DOUBLE_JUMP_VELOCITY = -600 #Second jump hight
@onready var timer = $DebuffTimer

var jumps_made = 0 #jump counter
var max_jumps = 2 # max jumps that character can make (galima keisti jeigu reikia)
var current_weapon = null
@onready var sprite_2d = $Sprite2D #calling the picture (sprite of a character)
@onready var RightCheckAbove =$RightCheckAbove #Check if there is an objec above player head on the right on the colider
@onready var LeftCheckAbove =$LeftCheckAbove #Check if there is an objec above player head on the left on the colider
@onready var RunningSound =$Running
@onready var JumpSound = $Jump
@onready var CroucingSound = $Crouching
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
			if not CroucingSound.playing:
				CroucingSound.play()
		else:
			CroucingSound.stop()
			sprite_2d.animation = "Crouching"
		#Swiches to crouching collider
		_crouchingcollison()
	elif Input.is_action_pressed("jump") and  is_on_floor():
		sprite_2d.animation = "jumping"
		RunningSound.stop()
		CroucingSound.stop()
		#Swiches back to normal collider
		_normalcollison()
	elif (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and (velocity.x>1 || velocity.x<-1) and is_on_floor():
		sprite_2d.animation = "Running"
		CroucingSound.stop()
		#Swiches back to normal collider
		_normalcollison()
		if not RunningSound.playing:
			RunningSound.play()
	elif is_on_floor():
		sprite_2d.animation = "idle"
		if RunningSound.playing:
			RunningSound.stop()
		if CroucingSound.playing:
			CroucingSound.stop()
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
		JumpSound.play()
	elif is_double_jumping:
		jumps_made += 1
		if jumps_made <= max_jumps:
			JumpSound.play()
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
	
	applyHealthCapacityPowerUp()

func _normalcollison():
	$HurtBox/HitBoxNormal.disabled = false
	$HurtBox/HitBoxCrouch.disabled = true
	$NormalColision.disabled = false
	$CrouchingColision.disabled = true
	
	#Handles speed
	if speedDebuf == false:
		SPEED = 300.0
	
	else:
		SPEED = 150
	
	JUMP_VELOCITY = -700
	DOUBLE_JUMP_VELOCITY = -600
	
	#Setting for crouching collision
func _crouchingcollison():
	$HurtBox/HitBoxNormal.disabled = true
	$HurtBox/HitBoxCrouch.disabled = false
	$NormalColision.disabled = true
	$CrouchingColision.disabled = false
	if speedDebuf == false:
		SPEED = 150
	else:
		SPEED = 75
	JUMP_VELOCITY = -500
	DOUBLE_JUMP_VELOCITY = -400


#Sets up health
func _ready():
	heartsContainer = $heartsContainer
	heartsContainer.setMaxHearts(Global.maxHealth)
	updateHealthGUI()
	check_weapon()

#Updates the health container to display correct hearts
func updateHealthGUI():
	heartsContainer.updateHearts(Global.currentHealth)

#Handles the damage taking logic
func healthDamage(takenDamage: int):
	if(Global.invincibility == true): #If power up is picked up the player cannot take damge for 10s 
		Global.currentHealth -= 0
	else:
		Global.currentHealth -= 1
		print(Global.currentHealth)
		updateHealthGUI()
		if Global.currentHealth <= 0:
			print("dead") #Change to quee free when respawn allowed
			Global.currentHealth = 3
			get_tree().change_scene_to_file("res://Assets/level/restart.tscn")

#Takes damage when hit by bullet
func _on_hurt_box_area_entered(area):
	var takenDamage
	if area.is_in_group("EnemyBullet"):
		takenDamage = 1
		healthDamage(takenDamage)
	#When hit with the smokers bullet slow down for set time
	if area.is_in_group("SmokerBullet"):
		timer.start() #Start debuf timer
		print("Slowed down")
		takenDamage = 1
		healthDamage(takenDamage)
		speedDebuf = true

#Checks global variable if health power-up was picked up
func applyHealthIncreasePowerUp():
	if Global.increasedHealth == true:
		updateHealthGUI()
		Global.increasedHealth = false

#Checks if global variable if health capacity is picked up
func applyHealthCapacityPowerUp():
	if Global.increasedCapacity == true:
		heartsContainer.setMaxHearts(1)
		updateHealthGUI()
		Global.increasedCapacity = false
		

func pick(item):
	#print(Global.has_uzi,Global.has_pistol)
	match item:
		"gun":
			var gun_instance = preload("res://Assets/Weapons/gun.tscn").instantiate()
			if current_weapon != null:
				current_weapon.queue_free()
			current_weapon = gun_instance
			add_child(gun_instance)
			gun_instance.global_position = global_position
			
		"pistol":
			var pistol_instance = preload("res://Assets/Weapons/Pistol/pistol.tscn").instantiate()
			if current_weapon != null:
				current_weapon.queue_free()
			current_weapon = pistol_instance
			add_child(pistol_instance)
			pistol_instance.global_position = global_position
			
		"sword":
			var sword_instance = preload("res://Assets/Weapons/Sword/sword.tscn").instantiate()
			if current_weapon != null:
				current_weapon.queue_free()
			current_weapon = sword_instance
			add_child(sword_instance)
			sword_instance.global_position = global_position
			
		"bat":
			var bat_instance = preload("res://Assets/Weapons/Bat/bat.tscn").instantiate()
			if current_weapon != null:
				current_weapon.queue_free()
			current_weapon = bat_instance
			add_child(bat_instance)
			bat_instance.global_position = global_position
			
		"axe":
			var axe_instance = preload("res://Assets/Weapons/Axe/axe.tscn").instantiate()
			if current_weapon != null:
				current_weapon.queue_free()
			current_weapon = axe_instance
			add_child(axe_instance)
			call_deferred("set_weapon_global_position", axe_instance, global_position)

func set_weapon_global_position(weapon_instance, position):
	weapon_instance.global_position = position



#
func check_weapon():
	if Global.has_uzi:
		var gun_instance = preload("res://Assets/Weapons/gun.tscn").instantiate()
		current_weapon = gun_instance
		add_child(gun_instance)
		gun_instance.global_position = global_position
	elif Global.has_pistol:
		var pistol_instance = preload("res://Assets/Weapons/Pistol/pistol.tscn").instantiate()
		current_weapon = pistol_instance
		add_child(pistol_instance)
		pistol_instance.global_position = global_position
	elif Global.has_sword:
		var sword_instance = preload("res://Assets/Weapons/Sword/sword.tscn").instantiate()
		current_weapon = sword_instance
		add_child(sword_instance)
		sword_instance.global_position = global_position
	elif Global.has_bat:
		var bat_instance = preload("res://Assets/Weapons/Bat/bat.tscn").instantiate()
		current_weapon = bat_instance
		add_child(bat_instance)
		bat_instance.global_position = global_position
	elif Global.has_axe:
		var axe_instance = preload("res://Assets/Weapons/Axe/axe.tscn").instantiate()
		current_weapon = axe_instance
		add_child(axe_instance)
		axe_instance.global_position = global_position

#When time runs out set the speed back to its original value
func _on_debuff_timer_timeout():
	speedDebuf = false
	print("Debuf ended")
