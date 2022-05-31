extends KinematicBody2D

export var move_speed = 200.0

var velocity := Vector2.ZERO
var mi_posicion
var tuberia = false
var caer = false
signal se_acabo
signal bote
signal pausar
signal despausar
signal dead
export var jump_height : float  
export var jump_time_to_peak : float  
export var jump_time_to_descent : float  
export var mini_jump : float = 20

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
onready var fireball := preload("res://Assets/Area2D.tscn")


#func _on_AnimationPlayer_animation_finished(Nueva_Animacion):
#	 emit_signal("animation_finished")
#func _on_Bowser_animation_finished():
#	print("a")
func _ready():
	if Global.bowser_estado == "crecido":
		self.scale = Vector2(1.0, 1.0)
	elif Global.bowser_estado == "pequeño":
		self.scale = Vector2(0.6, 0.6)

func _physics_process(delta):
	if not is_on_floor():
		move_speed = 10
	else:
		move_speed = 20
	if get_input_velocity() == 1:
		velocity.x = min(velocity.x + move_speed, 200)
		print("a")
	elif get_input_velocity() == -1:
		velocity.x = max(velocity.x + -move_speed, -200)
		print("b")
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y += get_gravity() * delta
	
	if is_on_floor():
		caer = false
		if Input.is_action_just_pressed("move_up"):
			jump()
	if Input.is_action_just_released("move_up") and not is_on_floor():
		caer = true
	velocity = move_and_slide(velocity, Vector2.UP)	
	pipe()
	detect_item()
	if Input.is_action_just_pressed("fire") and Global.bowser_estado == "fuego":
		fireball()
	if Global.bowser_estado == "fuego":
		animaciones_fire()
	else:
		animaciones()
	
	
	if self.position.y > 500:
		$AnimationPlayer.play("dies")
func get_gravity() -> float:
		return fall_gravity if velocity.y > 0.0 or caer == true else jump_gravity
	

func jump():
	velocity.y = jump_velocity

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal = -1.0
		$Bowser_Sprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		horizontal = 1.0
		$Bowser_Sprite.flip_h = true
	else: 
		horizontal = 0.0
	return horizontal

func pipe():
	if Input.is_action_pressed("move_down") and tuberia == true:
		$Bowser_Sprite.play("go_down")
		$AnimationPlayer.play("Nueva_Animacion")
		
		

func _on_AnimationPlayer_animation_started(Nueva_Animacion):
	if $AnimationPlayer.get_current_animation() == "Crecer":
		set_physics_process(false)
		


func _on_AnimationPlayer_animation_finished(Nueva_Animacion):
	emit_signal("se_acabo")
	if $AnimationPlayer.get_current_animation() != "Crecer":
		set_physics_process(true)
		emit_signal("despausar")
	if $AnimationPlayer.get_assigned_animation() == "dies":
		emit_signal("dead")
		
func _on_StaticBody2D_body_entered(body):
	if is_on_ceiling():
		emit_signal("bote")




func Animaciones():
	if $AnimationPlayer.get_assigned_animation() == "Crecer":
		set_physics_process(false)
	else:
		set_physics_process(true)





func detect_item():
	if get_parent().get_node("item"):
		var item =  get_parent().get_node("item")
		item.connect("change", self, "_change")
	
func _change():

	if Global.bowser_estado == "pequeño":
		emit_signal("pausar")
		get_parent().get_node("item").queue_free()
		$AnimationPlayer.play("Crecer")
		Global.bowser_estado = "crecido"
	elif Global.bowser_estado == "crecido":
		emit_signal("pausar")
		get_parent().get_node("item").queue_free()
		$Bowser_Sprite.play("Fire_Transformation")
		Global.bowser_estado = "fuego"
		set_physics_process(false)
	





func _on_Area2D_body_entered(body):
	if Global.bowser_estado == "pequeño":
		set_physics_process(false)	
		$AnimationPlayer.play("dies")
		$Damage_Checker/CollisionShape2D.set_disabled(true)
		$Bowser_Hitbox.set_disabled(true)
		$Bot_Checker/CollisionShape2D.set_disabled(true)
	elif Global.bowser_estado == "crecido":
		emit_signal("pausar")
		$AnimationPlayer.play_backwards("Crecer")
		Global.bowser_estado = "pequeño"
	elif Global.bowser_estado == "fuego":
		$Bowser_Sprite.play("Fire_Transformation", true)
		set_physics_process(false)
		Global.bowser_estado = "crecido"
func _on_Area2D_area_entered(area):
	$AnimationPlayer.play("dies")
	set_physics_process(false)


func _on_Bot_Checker_area_entered(area):
	if Input.is_action_pressed("move_up"):
		velocity.y = -mini_jump + jump_velocity
	else:
		velocity.y = -mini_jump

func fireball():
		$Bowser_Sprite.play("Fire")
		var fire = fireball.instance()
		get_parent().add_child(fire)
		fire.position = self.position
		if $Bowser_Sprite.flip_h == true:
			fire.speed = fire.speed * 1
			fire.position.x = self.position.x + 20
		elif $Bowser_Sprite.flip_h == false:
			fire.speed = fire.speed * -1
			fire.position.x = self.position.x - 20
		



func _on_Pipe_body_entered(body):
	tuberia = true
	print("A")

func _on_Pipe_body_exited(body):
	tuberia = false
	print("B")
func animaciones():
	if not $Bowser_Sprite.animation == "go_down":
		if Input.is_action_pressed("move_right") and not $Bowser_Sprite.animation == "Fire" or Input.is_action_pressed("left") and not $Bowser_Sprite.animation == "Fire":
			$Bowser_Sprite.play("default")
		elif Input.is_action_just_pressed("fire"):
			$Bowser_Sprite.play("Fire")
		elif not $Bowser_Sprite.animation == "Fire":
			$Bowser_Sprite.play("Idle")
			
		if $Bowser_Sprite.get_frame() == 4:
			$Bowser_Sprite.play("Idle")
		
func animaciones_fire():
	if not $Bowser_Sprite.animation == "go_down":
		if Input.is_action_pressed("move_right") and not $Bowser_Sprite.animation == "firefire" or Input.is_action_pressed("left") and not $Bowser_Sprite.animation == "firefire":
			$Bowser_Sprite.play("default_Fire")
		elif Input.is_action_just_pressed("fire"):
			$Bowser_Sprite.play("firefire")
		elif not $Bowser_Sprite.animation == "firefire":
			$Bowser_Sprite.play("Idle_Fire")
			
		if $Bowser_Sprite.get_frame() == 4:
			$Bowser_Sprite.play("Idle_Fire")


func _on_Bowser_Sprite_animation_finished():
	if $Bowser_Sprite.animation == "Fire_Transformation":
		set_physics_process(true)
		emit_signal("despausar")
