extends Area2D
@onready var sprite = $Sprite2D

func _ready():
	sprite.animation = "Spawn"
	$CollisionShape2D.disabled = true

func _physics_process(delta):
	if sprite.frame == 2:
		sprite.animation = "Idle"
		$CollisionShape2D.disabled = false


#If coin collected by player add 1 to coin collection
func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.collectedCurrency()
		print(Global.currency) #Used for testing
		queue_free()
