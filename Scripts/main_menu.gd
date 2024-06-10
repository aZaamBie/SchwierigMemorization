extends Control
### VARIABLES ###
var currentSet : int = 1
var currentSetContents

### FUNCTIONS ###
func _ready():
	pass # Replace with function body.
	$playSelect.hide()
	$optionSelect.hide()
	
	closeCset()
	$optionSelect/vboxCont/hslid_difficulty.value = Globals.difficulty_


func _process(delta):
	pass
	$optionSelect/vboxCont/lbl_difficulty.text = "Difficulty: " + str($optionSelect/vboxCont/hslid_difficulty.value)
	$optionSelect/vboxCont/lbl_perfRnds/lbl_count.text = str(Globals.perfectScore)
	
	
# MAIN(outer) BUTTONS
func _on_btn_play_pressed():
	$playSelect.show()
	checkCustoms()
	$sfx_select.play()
func _on_btn_options_pressed():
	$optionSelect.show()
	$sfx_select.play()
func _on_back_pressed():
	$playSelect.hide()
	$optionSelect.hide()
	$sfx_select.play()

func _on_btn_exit_pressed():
	get_tree().quit()


func checkCustoms():
	var len_
	if Globals.cSet1 == []: $playSelect/vboxCustom/btn_set1.text = "Set 1 (empty)"
	else:
		len_ = len(Globals.cSet1)
		$playSelect/vboxCustom/btn_set1.text = "Set 1 (" + str(len_) + " elements)"
		#print("Custom set 1 not empty anymore")
	
	if Globals.cSet2 == []: $playSelect/vboxCustom/btn_set2.text = "Set 2 (empty)"
	else:
		len_ = len(Globals.cSet2)
		$playSelect/vboxCustom/btn_set2.text = "Set 2 (" + str(len_) + " elements)"
		#print("Custom set 2 not empty anymore")
	
	if Globals.cSet3 == []:$playSelect/vboxCustom/btn_set3.text = "Set 3 (empty)"
	else:
		len_ = len(Globals.cSet3)
		$playSelect/vboxCustom/btn_set3.text = "Set 3 (" + str(len_) + " elements)"
		#print("Custom set 3 not empty anymore")

## BUTTON PRESSES
func _on_btn_set_phy_pressed():
	pass # Replace with function body.
	currentSet = 11
	openCset(Globals.setPhy, "[hysucs]") #1

func _on_btn_set_mam_pressed():
	pass # Replace with function body.
	currentSet = 12
	openCset(Globals.setMam, "Mathematics") # 2

func _on_btn_set_cs_pressed():
	pass # Replace with function body.
	currentSet = 13
	openCset(Globals.setCS, "Computer Science") # 2

func _on_btn_set_1_pressed():
	#if Globals.cSet1 == []:
	currentSet = 1
	#currentSet = Globals.cSet1
	openCset(Globals.cSet1, 1) # (Globals.cSet1)
	
func _on_btn_set_2_pressed():
	currentSet = 2
	openCset(Globals.cSet2, 2) # (Globals.cSet2)
	
func _on_btn_set_3_pressed():
	currentSet = 3
	openCset(Globals.cSet3, 3) # (Globals.cSet3)

##

func openCset(contents, setIND=null):
	print(currentSet, " is the current set")
	
	currentSetContents = contents
	var cset = $playSelect/cSet_edit
	cset.show()
	
	if setIND!= null:
		#$playSelect/cSet_edit.text = str( contents )
		for i in contents:
			if i=="": pass # dont count if character is blank
			else: $playSelect/cSet_edit.text += str(i) + "\n" # otherwise, add characters to text box
		
		$playSelect/cSet_edit.placeholder_text = "Enter words for: set " + str(setIND)
		
func closeCset():
	var cset = $playSelect/cSet_edit
	cset.hide()
	$playSelect/cSet_edit.placeholder_text = "Enter words for: set"
	
	$playSelect/cSet_edit.text = ""
	checkCustoms()
	


func _on_confirm_c_set_pressed():
	var wordList = []
	var confirm : bool = false
	
	wordList = $playSelect/cSet_edit.text.split("\n") # separate text by the newline char; put into array
	
	if len(wordList) >=2:
		confirm = true
	else:
		pass
		OS.alert("You need two or more items in a list to continue!","Can't confirm!!")
	
	# custom sets
	if currentSet == 1:
		Globals.cSet1 = wordList#currentSetContents 
	elif currentSet == 2:
		Globals.cSet2 = wordList#currentSetContents
	elif currentSet == 3:
		Globals.cSet3 = wordList#currentSetContents
	
	elif currentSet == 11:
		Globals.setPhy = wordList
	elif currentSet == 12:
		Globals.setMam = wordList
	elif currentSet == 13:
		Globals.setCS = wordList
	
	
	currentSetContents = wordList
	
	if confirm:
		$playSelect/cSet_edit/play_cSet.disabled = false
	else:
		pass

func _on_back_c_set_pressed():
	closeCset()


func _on_save_btn_pressed():
	pass # Replace with function body.
	Globals.save_score()
	OS.alert("Data has been saved successfully (Custom sets and Difficulty level)","ALERT! Successful save.")
	$sfx_save.play()
func _on_clear_btn_pressed():
	pass # Replace with function body.
	OS.alert("All sets will be cleard and all data in there will be list. ","ALERT! All datat will be cleared")
	Globals.clearSets()


func _on_play_c_set_pressed():
	pass # Replace with function body.
	Globals.currentSet_play = currentSetContents
	get_tree().change_scene_to_file("res://Scenes/word_tester.tscn")


## OPTIONS

func _on_hslid_difficulty_drag_ended(value_changed):
	pass # Replace with function body.
	Globals.difficulty_ = $optionSelect/vboxCont/hslid_difficulty.value
