extends Area2D

#var RIGHT = Vector2.RIGHT
var direction : Vector2 = Vector2.RIGHT
var speed = 6

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	position += direction * speed

func destroy():
	queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		destroy()
