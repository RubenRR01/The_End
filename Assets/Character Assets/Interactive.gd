extends Node2D

onready var tilemap = $Interactive

const BLOCK = preload("res://Assets/Character Assets/StaticBody2D.tscn") 
const Mushroom_Block = preload("res://Assets/Character Assets/Mushroom_Block.tscn")

func _ready():
	
	print(tilemap.get_used_cells_by_id(4))
	
	print(tilemap.get_used_cells_by_id(0))
	for cellpos in tilemap.get_used_cells_by_id(0):
		var cell = tilemap.get_cellv(cellpos) 
		var object = BLOCK.instance()
		object.position = tilemap.map_to_world(cellpos) + Vector2(7.9, 7.7)
		add_child(object)
		tilemap.set_cellv(cellpos, -1)
			
	
	for cellpos in tilemap.get_used_cells_by_id(4):
		var cell = tilemap.get_cellv(cellpos)
		print("a")
		var object = Mushroom_Block.instance()
		object.position = tilemap.map_to_world(cellpos) + Vector2(8, 7.7)
		add_child(object)
		tilemap.set_cellv(cellpos, -1)
			


func _on_Bowser_pausar():
	get_tree().set_pause(true)


func _on_Bowser_despausar():
	get_tree().set_pause(false)



func mamahuevo():
	pass # Replace with function body.


func _on_Bowser_dead():
	Global.bowser_estado = "pequeño"
	get_tree().reload_current_scene()
