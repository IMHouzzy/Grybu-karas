extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_pistol:
		Global.has_pistol =true
		Global.has_uzi =false
		Global.has_sword =false
		Global.has_axe =false
		Global.has_bat =false
		body.pick("pistol")
		queue_free()
	elif body.is_in_group("player") and Global.has_pistol:
		queue_free()
