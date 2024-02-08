extends Node

const BLOCK_MASK_COLOR = Color(0.4, 0.4, 0.4)

var solid_block:PackedScene
var blocks:Array
var block_material:ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	solid_block = preload("res://scenes/blocks/block.tscn")
	block_material = preload("res://materials/block_shader_material.tres")


func set_block(block_pos:Vector3):
	var new_block:Node3D = solid_block.instantiate()
	
	new_block.position = block_pos
	# Instance uniform is not supported by gl_compability yet
	# $MeshInstance3D.set_instance_shader_parameter("", block_type)
	
	add_child(new_block)
	return new_block


func remove_block(block:Node3D):
	block.queue_free()


func highlight_block(block_pos:Vector3, block_normal:Vector3, block_mask_color:Color = BLOCK_MASK_COLOR):
	block_mask_color = block_mask_color*(1+0.2*sin(2*PI*(Time.get_ticks_msec()%1000)*0.001))
	block_material.set_shader_parameter("highlight_block_pos", block_pos)
	block_material.set_shader_parameter("highlight_block_normal", block_normal)
	block_material.set_shader_parameter("highlight_block_mask_color", block_mask_color)


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


func _on_player_highlight_block(block_pose, block_normal, block_mask_color = BLOCK_MASK_COLOR):
	highlight_block(block_pose, block_normal, block_mask_color)
