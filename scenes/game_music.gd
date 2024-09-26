extends AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	play()
	get_tree().get_first_node_in_group("player").game_over.connect(stop)
	finished.connect(play)
