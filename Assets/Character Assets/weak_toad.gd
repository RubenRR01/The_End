extends KinematicBody2D
var speed = 100
var direction = -1
var motion : Vector2
var gravity = 50

func _ready():
	set_physics_process(false)
func _physics_process(delta):
	if is_on_wall():
		direction = direction * -1
	motion.x = speed * direction
	motion.y = gravity
	
	motion = move_and_slide(motion, Vector2.UP)





func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "die":
		queue_free()


func _on_Area2D_area_entered(area):
	$CollisionShape2D.queue_free()
	$Area2D/CollisionShape2D.queue_free()
	set_physics_process(false)
	$AnimatedSprite.play("die")


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	set_physics_process(true)
