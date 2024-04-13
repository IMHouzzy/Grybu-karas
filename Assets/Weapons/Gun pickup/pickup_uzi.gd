extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_uzi:
		Global.has_uzi =true
		Global.has_pistol =false
		body.pick("gun")
		queue_free()
	else:
		queue_free()
