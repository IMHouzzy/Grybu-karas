extends Area2D
@onready var sprite = $Sprite2D
@onready var Powerup = $Powerup
var pick:bool = false
func _physics_process(delta):
	if pick:
		Powerup.play()
		pick =false

#When the body is enetered give the player 1 health
func _on_body_entered(body):
	print("Body entered:", body.name)
	if body.is_in_group("player"):
		pick = true
		print("Player entered the power-up area")
		if Global.currentHealth < Global.maxHealth: #If the current health is less than max give 1 health
			print("")
			print("add 1 health")			
			print("Max Health: ", str(Global.maxHealth))
			print("Current health: ", str(Global.currentHealth))
			Global.currentHealth += 1
			Global.increasedHealth = true
			set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact
			await get_tree().create_timer(1).timeout
			queue_free()
		else:
			print("")
			print("Hhahah dont get it")
			print("Max Health: ", str(Global.maxHealth))
			print("Current health: ", str(Global.currentHealth))
			set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact
			await get_tree().create_timer(1).timeout
			queue_free()

