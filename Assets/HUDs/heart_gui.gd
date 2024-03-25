extends Panel

enum HeartState { FULL, THREE_QUARTER, HALF, QUARTER, EMPTY }

@onready var sprite = $Sprite2D
var currentState = HeartState.FULL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Fix this up
func updateState():
	match currentState:
		HeartState.FULL:
			sprite.frame = 0  # Full heart sprite
		HeartState.THREE_QUARTER:
			sprite.frame = 1  # 3/4 heart sprite
		HeartState.HALF:
			sprite.frame = 2  # 1/2 heart sprite
		HeartState.QUARTER:
			sprite.frame = 3  # 1/4 heart sprite
		HeartState.EMPTY:
			sprite.disabled  # Empty heart sprite

func setState(state: HeartState):
	currentState = state
	updateState()
