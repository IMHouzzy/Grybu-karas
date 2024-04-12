extends Area2D
@onready var sprite = $Sprite2D
@onready var Collect = $Collect
var pick:bool = false
func _ready():
	sprite.animation = "Spawn"
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	if sprite.frame == 2:
		sprite.animation = "Idle"
		$CollisionShape2D.disabled = false
	if pick:
		Collect.play()
		pick =false
		


#If coin collected by player add 1 to coin collection
func _on_body_entered(body):
	if body.is_in_group("player"):
		pick =true
		Global.collectedCurrency()
		print(Global.currency) #Used for testing
		set_visibility_layer_bit(0,false) #Makes it invisible so it works, but cant interact
		await get_tree().create_timer(1).timeout
		queue_free()
