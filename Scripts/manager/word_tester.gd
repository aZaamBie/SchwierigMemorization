extends Control
### VARIABLES ###

@export var lvlIncFactor : float = 1.0
@export var increasefactor : float = 0.5
@export_range(0.1,2.0) var loadSpeed : float = 1.0

@export var wordList_tst : Array = ["Physics", "Math", "Computer Science"]

@onready var txtHold = $Screen/txtScreen
@onready var animFdback = $Screen/Display/animFeedback
@onready var timer_ = $Timer

var timerDur : float = 1.0 # default countdown timer

var originalList = []
var currentList
var currentLvl = 1
var IND_list = 0 # index for the current

var cntCorrect = 0 # counter for correct
var cntIncorrect = 0 # counter for incorrect

#var comboCount = 0
#var highestCombo = 0

var intro_ : bool = false
var canType : bool = false
var lvlFinished : bool = false

### --------- ###
### FUNCTIONS ###
func _ready():
	randomize() 
	
	loadSpeed = Globals.difficulty_ # connect the local to the Global difficulty variable
	
	if Globals.currentSet_play == []: # if all data empty, then choose a test word list
		currentList = wordList_tst
	else:
		currentList = Globals.currentSet_play # otherwise, use the set that player chose
		currentList = configList(currentList)
		
		originalList = Globals.currentSet_play # FOR THE OG
		originalList = configList(originalList)
	
	mainStart()


func configList(list_:Array): # sets up the list; makes sure no empty characters are added to new list
	var newList_ = []
	for i in list_:
		if i == "": pass
		else: newList_.append(i)
	return newList_

func timer(delta_): # countdown timer
	timerDur -= delta_
	var min : int = fmod(timerDur,3600) / 60
	var sec : int = fmod(timerDur,60)
	var msec : int = fmod(timerDur,1) * 1000

	$Screen/Display/lbl_timer.text = str(sec).pad_zeros(2) + ":" + str(msec).pad_zeros(2)

func _process(delta):
	if canType and !lvlFinished:
		timer(delta)
	if timerDur <= 0.0 and canType and !lvlFinished:
		canType = false
		lvlFinished = true
		levelFinished()
		set_process(false)

func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and canType:
		
		if $input/box/text.has_focus(): # Disables the "enter" for the text edit. 
			#BUG causes problems when submitting the current input. It would clear text BUT go to next line.
			# NEW BUG: Invalid get index 'key_label' (on base: 'InputEventMouseMotion').
			
			#if event.key_label == KEY_ENTER and event != InputEventMouseMotion: #if event.key_label == KEY_SPACE or event.key_label == KEY_ENTER:
				#get_viewport().set_input_as_handled()
			#else: pass
			
			if event != InputEventMouseMotion: #if event.key_label == KEY_SPACE or event.key_label == KEY_ENTER:
				get_viewport().set_input_as_handled()
			else: pass
			
		var txt_ = $input/box/text.text 
		
		addText(txt_)
		
		if checkText(txt_,currentList,IND_list):
			$input/box/existWords/Panel/currentTXT.text += txt_ + "; "
			displayRes(true)
			
			# style rank
			$Screen/StyleRank.increaseRank()
		else:
			pass
			displayRes(false)
			
			# style rank
			$Screen/StyleRank.decreaseRank()
		
		IND_list += 1
		
		await  get_tree().create_timer(1).timeout
		checkFinish()


func mainStart():
	# randomize the list to be shown
	randomize()
	currentList.shuffle() # randomize the order of the current list
	originalList.shuffle() # randomize the original UNSLICED list
	
	#print(Globals.numWordsToTest, " is GLOBAL VAR length")
	#print(len(currentList), " is length from main start")
	
	if Globals.numWordsToTest > len(currentList): # check whether: global num of words surpasses current list len
		Globals.numWordsToTest = len(currentList) # assign global to the current len
		#print(Globals.numWordsToTest, " is GLOBAL VAR length")
	
	# slice out the desired number of elements to be tested. Start from first word
	currentList = originalList.slice(0,Globals.numWordsToTest) # slice from original, unchanged list
	
	# initialize buttons, text box cleared, loadSpeed
	set_process(true)
	lvlFinished = false
	cntCorrect = 0
	cntIncorrect = 0
	IND_list = 0
	
	$Screen/StyleRank.init_()
	
	#buttons
	$Screen/btn_nxtlvl.disabled = true
	$Screen/btn_nxtlvl.hide()
	
	$Screen/btn_redo.disabled = true
	$Screen/btn_redo.hide()
	
	$Screen/Display/btn_mainMenu.disabled = true
	$Screen/Display/btn_mainMenu.hide()
	
	# labels
	$Screen/lbl_Perfect.hide()
	$Screen/lbl_Perfect/sfx_fire.stop()
	
	$Screen/Display/lvl.text = "Level: " + str(currentLvl)
	$input/box/text.clear()
	$input/box/existWords/Panel/currentTXT.text = " "
	
	$Screen/Display/lbl_timer.text = "??:??"
	
	loadSpeed = Globals.difficulty_
	
	#- show text
	txtHold.text = "Memorise the words as fast as possible"
	await get_tree().create_timer(1.5).timeout 
	txtHold.text = "Then type those words in the order that they were presented"
	await get_tree().create_timer(1.5).timeout 
	txtHold.text = "Ready?"
	await get_tree().create_timer(1).timeout 
	txtHold.text = "Go!"
	await get_tree().create_timer(0.5).timeout 
	
	#randomize()
	#currentList.shuffle() # randomize the order of the current list
	
	showText(currentList)
	
	await get_tree().create_timer(0.5).timeout 

	intro_ = false



func showText(list_:Array):
	for i in list_:
		if i != "" or i!= " ": # make sure the current elemnt isn't blank
			# get length of current word(s)
			var len_ = len(i)
			# roughly calculate the amount of time that text should stay up.
			var duration = len_ / ( loadSpeed * 7 * lvlIncFactor)  # ( loadSpeed * 7) 
			
			txtHold.show()
			txtHold.text = str(i)
			await get_tree().create_timer(duration).timeout 
			txtHold.hide()
			
			if i == list_[len(list_)-1]: # if last word is hidden, then start the typing
				canType = true
			timerDur += float(duration*5) # add the durations to the countdown timer duration

func addText(text_:String):
	var userText = $input/box/existWords/Panel/currentTXT.text
	$input/box/text.clear() # clear text box after text was submitted


func checkText(word,list,listInd):
	if canType: # prevent text comparisons when disbaled (e.g. when text still showing, or when list finished)
		checkFinish()
		if word == list[listInd] and (listInd<= len(list)):
			return true
		else:
			return false

func displayRes(Correct:bool): # display the result
	if Correct:
		animFdback.play("Correct")
		cntCorrect += 1
	else:
		animFdback.play("Incorrect")
		cntIncorrect += 1


###--- ROUND CHECKS ---###

func checkFinish(): # check whether level is finished
	
	if (IND_list > (len(currentList)-1)) and canType: # first check whether list is finished; no more words in list # >=
		levelFinished()
		return

func levelFinished():
	canType = false
	checkCounters(cntCorrect,cntIncorrect)

func checkCounters(cnter1,cnter2):
	# first show the main menu button
	$Screen/Display/btn_mainMenu.show()
	$Screen/Display/btn_mainMenu.disabled = false
	
	if cnter1 > cnter2 and IND_list == ( len(currentList) ): # win phase and timer not out
		animFdback.play("roundWIN")
		
		# enable the next level button
		$Screen/btn_nxtlvl.disabled = false
		$Screen/btn_nxtlvl.show()
		
		if cnter2==0: # PERFECT ROUND (no wrong)
			# enable the "PERFECT score counter"
			$Screen/lbl_Perfect.show()
			$Screen/lbl_Perfect/anim.play("loop")
			Globals.perfectScore += 1
			$Screen/lbl_Perfect/lbl_counter.text = "No. of perfect rounds: " + str(Globals.perfectScore)
	
	else: # lose phase
		animFdback.play("roundLOSE")
		
		# enable the redo button
		$Screen/btn_redo.disabled = false
		$Screen/btn_redo.show()
	
	timer_.stop()
	txtHold.show()
	txtHold.text = "Correct: " + str(cntCorrect) + "\n" + "Incorrect: " + str(cntIncorrect)
	
	lvlFinished = true


func nextLevel(lvl_:int):
	currentLvl += 1
	
	lvlIncFactor += increasefactor #increase constant by 1. this should shorten the total duration
	
	Globals.save_score()
	mainStart()

func _on_btn_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_btn_redo_pressed():
	mainStart()

func _on_btn_nxtlvl_pressed():
	nextLevel(Globals.difficulty_)

func _on_timer_timeout():
	canType = false
	lvlFinished = true
	levelFinished()
