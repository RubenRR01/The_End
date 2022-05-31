extends KinematicBody2D
var motion = Vector2.ZERO
var direction = 1
var speed = 35
export var pixels_moved : float

var player_position: int
var enemie_spawn = false
var enemie = false


func _physics_process(delta):
	motion = move_and_slide(motion, Vector2.UP)
	print($AnimatedSprite.get_frame())
	loop_movement()


	

	
func loop_movement():
	motion.y = -speed * direction
	pixels_moved =  pixels_moved + motion.y
	if pixels_moved >= 1000 or pixels_moved <= -1000:
		direction *= -1





func _exit_tree():
	emit_signal("tree_exiting")
	





func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "die":
		queue_free()


func _on_Area2D_area_entered(area):
	$CollisionShape2D.queue_free()
	$Area2D/CollisionShape2D.queue_free()
	set_physics_process(false)
	$AnimatedSprite.play("die")
	

