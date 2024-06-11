extends Panel


func _ready():
	pass # Replace with function body.
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !self.visible
		if get_tree().paused == false:
			get_tree().paused = true
		else:
			get_tree().paused = true
		
		print(get_tree().paused)


func _on_btn_options_pressed():
	pass # Replace with function body.


func _on_btn_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_btn_quit_pressed():
	pass # Replace with function body.
	get_tree().quit()
