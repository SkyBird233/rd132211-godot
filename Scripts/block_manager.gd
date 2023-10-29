@tool
extends Node

var solid_block:PackedScene
var blocks:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	solid_block = preload("res://Scenes/Blocks/block.tscn")


func set_block(block_pos:Vector3, block_type:int = -1):
	var new_block:Node3D = solid_block.instantiate()
	
	new_block.position = block_pos
	# Instance uniform is not supported by gl_compability yet
	# $MeshInstance3D.set_instance_shader_parameter("", block_type)
	
	add_child(new_block)
	return new_block


func remove_block(block:Node3D):
	block.queue_free()


func gen_initial_platform(r = 5):
	for block in get_children():
		remove_child(block)
		block.queue_free()
	for i in range(5):
		for j in range(-r, r):
			for k in range(-r, r):
				set_block(Vector3(j, -i, k))


func _on_player_place_block(block_pos):
	set_block(block_pos)


func _on_player_mine_block(block):
	remove_block(block)

