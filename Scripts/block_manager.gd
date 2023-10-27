@tool
extends Node

var grass_block:PackedScene
var stone_block:PackedScene
var blocks:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	grass_block = preload("res://Scenes/Blocks/grass.tscn")
	stone_block = preload("res://Scenes/Blocks/stone.tscn")
	blocks = [grass_block, stone_block]


func set_block(block_pos:Vector3, block_type:int = -1):
	if block_type == -1:
		if abs(block_pos.y)<0.1: block_type = 0
		else: block_type = 1
	var new_block:Node3D = blocks[block_type].instantiate()
	new_block.position = block_pos
	add_child(new_block)
	return new_block

func remove_block(block:Node3D):
	block.queue_free()


func gen_initial_platform(range = 5):
	for block in get_children():
		remove_child(block)
		block.queue_free()
	for i in range(5):
		for j in range(-range, range):
			for k in range(-range, range):
				set_block(Vector3(j, -i, k))


func _on_player_place_block(block_pos):
	set_block(block_pos)


func _on_player_mine_block(block):
	remove_block(block)

