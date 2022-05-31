extends Area2D

export var speed := 4
func _ready():
	pass
func _physics_process(delta):
	position.x += speed
	if speed == 4:
		$AnimatedSprite.flip_h = true
	elif speed == -speed:
		$AnimatedSprite.flip_h = false



func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
