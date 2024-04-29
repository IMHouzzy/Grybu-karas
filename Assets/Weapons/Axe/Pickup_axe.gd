extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_axe:
		Global.has_axe =true
		Global.has_sword =false
		Global.has_bat =false
		Global.has_pistol =false
		Global.has_uzi =false
		body.pick("axe")
		queue_free()
	elif body.is_in_group("player") and Global.has_axe:
		queue_free()
