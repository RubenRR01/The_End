extends KinematicBody2D
signal change
var move = 50
var motion = Vector2.ZERO
var direction = -1
var gravity = 50
func _physics_process(delta):
	if is_on_wall()  and is_on_floor():
		direction = direction * -1
	motion.x = move * direction
	motion.y = gravity
	motion = move_and_slide(motion, Vector2.UP)





func _on_Area2D_body_entered(body):
	print("a")
	self.set_name("item")	
func _process(delta):
	if self.name == "item":
		emit_signal("change")
