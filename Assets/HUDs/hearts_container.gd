extends HBoxContainer

@onready var HeartGuiClass = preload("res://Assets/HUDs/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

#Add code here for it to work
func updateHearts(currentHealth: int, maxHealth: int):
	pass
