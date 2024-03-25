extends Panel

@onready var spriteFull = $Sprite2D
@onready var spriteEmpty = $Sprite2D2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Fix this up
func update(whole: bool):
	if whole: 
		spriteFull.visible = true
		spriteEmpty.visible = false
	else:
		spriteFull.visible = false
		spriteEmpty.visible = true

