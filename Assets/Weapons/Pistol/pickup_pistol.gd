extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_pistol:
		Global.has_pistol =true
		Global.has_uzi =false
		body.pick("pistol")
		queue_free()
	else:
		queue_free()
