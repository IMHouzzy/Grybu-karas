extends Area2D


var direction = Vector2.RIGHT
var speed = 600

func _physics_process(delta):
	position += direction * speed * delta

func destroy():
	queue_free()
	
func _on_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		destroy()
