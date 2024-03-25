extends CanvasLayer


#Adds coins count to HUD
func _ready():
	$CoinCount.text = str(Global.currency)

#Basically does the same, just updates everytime its picked up
func _process(delta):
	$CoinCount.text = str(Global.currency)
