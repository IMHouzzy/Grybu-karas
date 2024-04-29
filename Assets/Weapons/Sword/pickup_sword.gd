extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !Global.has_sword:
		Global.has_sword =true
		Global.has_axe =false
		Global.has_bat =false
		Global.has_pistol =false
		Global.has_uzi =false
		body.pick("sword")
		queue_free()
	elif body.is_in_group("player") and Global.has_sword:
		queue_free()
