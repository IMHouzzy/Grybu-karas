extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Adds additional Heart 
func _on_body_entered(body):
	if body.is_in_group("player"):
		if Global.maxHealth < 6:
			Global.maxHealth += 1
			Global.increasedCapacity = true
			print(Global.maxHealth)
			queue_free()
		else:
			queue_free()
