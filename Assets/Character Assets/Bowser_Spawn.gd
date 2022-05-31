extends Position2D

onready var Bowser = preload("res://Assets/Character Assets/Bowser.tscn")
func _physics_process(delta):
	var counter = 0
	var bowser = Bowser.instance()
	get_parent().add_child(bowser)
	counter += 1
	bowser.position = self.position
	if counter == 1:
		self.queue_free()
