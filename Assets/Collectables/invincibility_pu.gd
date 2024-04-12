extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		$Timer.start() #Starts a timer
		print("Timer for [INVINCIBILITY] started")
		Global.invincibility = true
		set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact


func _on_timer_timeout():
	print("Timer for [INVINCIBILITY] stopped")
	Global.invincibility = false
	queue_free()
