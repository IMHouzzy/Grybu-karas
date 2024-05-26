extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _pressed():
	get_tree().change_scene_to_file("res://Assets/level/level_"+ str(Global.level)+"_.tscn")

	Global.increasedHealth = false
	Global.increasedCapacity = false
	Global.increasedDamage = false
	Global.invincibility = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
