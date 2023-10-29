@tool
extends EditorScript

func _run():
	print('gen_initial_platform')
	gen(4)
	

func gen(r = 5):
	var block_manager = get_scene().get_node("BlockManager")
	
	for block in block_manager.get_children():
		block_manager.remove_child(block)
		block.queue_free()

	for i in range(5):
		for j in range(-r, r):
			for k in range(-r, r):
				block_manager.set_block(Vector3(j, -i, k)).set_owner(get_scene())
