extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$playSelect.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_play_pressed():
	$playSelect.show()

func _on_back_pressed():
	$playSelect.hide()


func _on_btn_exit_pressed():
	get_tree().quit()
