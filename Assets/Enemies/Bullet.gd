extends Area2D

#var RIGHT = Vector2.RIGHT
var direction : Vector2 = Vector2.RIGHT
var speed = 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * speed

func destroy():
	queue_free()

#if it leaves the screen delete the bullet
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		destroy()
