extends Area2D

const FILE_BEGIN = "res://Assets/level/level_"

func _on_body_entered(body):
	if body.is_in_group("player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		Global.level += 1
		var next_level_number = current_scene_file.to_int()+1
		var next_level_path = FILE_BEGIN + str(next_level_number)+"_.tscn"
		Transition.chnage_scene(next_level_path)
		print(current_scene_file)
