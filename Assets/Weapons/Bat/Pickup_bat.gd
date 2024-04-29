extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_bat:
		Global.has_bat =true
		Global.has_sword =false
		Global.has_axe =false
		Global.has_pistol =false
		Global.has_uzi =false
		body.pick("bat")
		queue_free()
	elif body.is_in_group("player") and Global.has_bat:
		queue_free()
