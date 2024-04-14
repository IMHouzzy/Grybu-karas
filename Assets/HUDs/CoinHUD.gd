extends CanvasLayer
@onready var spriteInvin = $invincibility
@onready var spriteDamage = $damage_increase
#Adds coins count to HUD
func _ready():
	$CoinCount.text = str(Global.currency)
	spriteInvin.visible = false
	spriteDamage.visible = false

#Basically does the same, just updates everytime its picked up
func _process(delta):
	$CoinCount.text = str(Global.currency)
	invincibilityHUD()
	damageIncreaseHUD()

func invincibilityHUD():
	if(Global.invincibility == true):
		spriteInvin.visible = true
	else:
		spriteInvin.visible = false

func damageIncreaseHUD():
	if(Global.increasedDamage == true):
		spriteDamage.visible = true
	else:
		spriteDamage.visible = false
