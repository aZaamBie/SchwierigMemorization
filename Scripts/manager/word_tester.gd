extends Control
### VARIABLES

@export var lvlIncFactor : float = 1.0
@export_range(0.1,2.0) var loadSpeed : float = 1.0

@export var wordList_tst : Array = ["Physics", "Math", "Computer Science"]

@onready var txtHold = $Screen/txtScreen
@onready var animFdback = $Screen/Display/animFeedback


var timerDur : float = 5.0 # default countdown timer

var currentList
var currentLvl = 1
var IND_list = 0 # index for the current

var cntCorrect = 0
var cntIncorrect = 0

var comboCount = 0
var highestCombo = 0

var intro_ : bool = false
var canType : bool = false
var lvlFinished : bool = false

### FUNCTIONS
func _ready():
	loadSpeed = Globals.difficulty_ # connect the local to the Global difficulty variable
	
	if Globals.currentSet_play == []: # if all data empty, then choose a test word list
		currentList = wordList_tst
	else:
		currentList = Globals.currentSet_play # otherwise, use the set that player chose
	
	mainStart()


func _process(delta):
	pass
	#if !intro_:
		#mainLoop()
	#while !lvlFinished and canType:
		#pass


func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and canType:
		checkFinish() 
		
		if $input/box/text.has_focus(): # Disables the "enter" for the text edit. 
			#BUG causes problems when submitting the current input. It would clear text BUT go to next line.
			if event.key_label == KEY_ENTER: #if event.key_label == KEY_SPACE or event.key_label == KEY_ENTER:
				get_viewport().set_input_as_handled()

		var txt_ = $input/box/text.text 
		
		addText(txt_)
		
		if checkText(txt_,currentList,IND_list):
			pass
			$input/box/existWords/Panel/currentTXT.text += txt_ + "; "
			displayRes(true)
		else:
			pass
			displayRes(false)
		
		IND_list += 1
		
		await  get_tree().create_timer(1.5).timeout
		checkFinish()



func mainStart():
	# initialize buttons, text box cleared, loadSpeed
	cntCorrect = 0
	cntIncorrect = 0
	
	$Screen/btn_nxtlvl.disabled = true
	$Screen/btn_nxtlvl.hide()
	
	$Screen/btn_redo.disabled = true
	$Screen/btn_redo.hide()
	
	$Screen/lbl_Perfect.hide()
	$Screen/lbl_Perfect/sfx_fire.stop()
	
	
	$Screen/Display/lvl.text = "Level: " + str(currentLvl)
	$input/box/text.clear()
	$input/box/existWords/Panel/currentTXT.text = " "
	
	loadSpeed = Globals.difficulty_
	
	# show text
	txtHold.text = "Memorise the words as fast as possible"
	await get_tree().create_timer(1.5).timeout 
	txtHold.text = "Then type those words in the order that they were presented"
	await get_tree().create_timer(1.5).timeout 
	txtHold.text = "Ready?"
	await get_tree().create_timer(1).timeout 
	txtHold.text = "Go!"
	await get_tree().create_timer(0.5).timeout 
	
	showText(currentList)
	
	await get_tree().create_timer(0.5).timeout 
	canType = true
	intro_ = false
	

func showText(list_:Array):
	for i in list_:
		if i != "" or i!= " ": # make sure the current elemnt isn't blank
			# get length of current word(s)
			var len_ = len(i)
			# roughly calculate the amount of time that text should stay up.
			var duration = len_ / ( loadSpeed * 7)
			
			txtHold.show()
			txtHold.text = str(i)
			await get_tree().create_timer(duration).timeout 
			txtHold.hide()

func addText(text_:String):
	var userText = $input/box/existWords/Panel/currentTXT.text
	$input/box/text.clear() # clear text box after text was submitted
	#$input/box/text.placeholder_text = "..."


func checkText(word,list,listInd):

	if canType: # prevent text comparisons when disbaled (e.g. when text still showing, or when list finished)
		checkFinish()
		#print(listInd, " while", ( len(list) -2) )
		#if (listInd>= (len(list)-1) ): # if (listInd>=len(list)):
			#levelFinished()
			#return
		if word == list[listInd]:# and (listInd<= len(list)):
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
	if (IND_list > (len(currentList)-1)): # first check whether list is finished; no more words in list # >=
		levelFinished()
		return

func levelFinished():
	canType = false
	checkCounters(cntCorrect,cntIncorrect)

func checkCounters(cnter1,cnter2):
	if cnter1 > cnter2: # win phase
		pass
		animFdback.play("roundWIN")
		
		# enable the next level button
		$Screen/btn_nxtlvl.disabled = false
		$Screen/btn_nxtlvl.show()
		
		if cnter2==0: # no wrong answer; PERFECT ROUND
			pass
			# enable the "PERFECT score counter"
			$Screen/lbl_Perfect.show()
			$Screen/lbl_Perfect/anim.play("loop")
			Globals.perfectScore += 1
			$Screen/lbl_Perfect/lbl_counter.text = "No. of perfect rounds: " + str(Globals.perfectScore)
	
	#elif cnter2==0: # no wrong answers ; PERFECT ROUND
		#pass
		## enable the "PERFECT score counter"
		#$Screen/lbl_Perfect.show()
		#$Screen/lbl_Perfect.show()
		#$Screen/lbl_Perfect/anim.play("loop")
		#Globals.perfectScore += 1
		#$Screen/lbl_Perfect/lbl_counter.text = "No. of perfect rounds: " + str(Globals.perfectScore)
	
	else: # lose phase
		animFdback.play("roundLOSE")
		
		# enable the redo button
		$Screen/btn_redo.disabled = false
		$Screen/btn_redo.show()
	
	txtHold.show()
	txtHold.text = "Correct: " + str(cntCorrect) + "\n" + "Incorrect: " + str(cntIncorrect)
	
	lvlFinished = true


func nextLevel(lvl_:int):
	pass
	currentLvl += 1
	lvl_ += lvlIncFactor
	loadSpeed = lvl_ # current loadspeed = new, changed loadspeed
	mainStart()

func _on_btn_redo_pressed():
	pass # Replace with function body.
	mainStart()

func _on_btn_nxtlvl_pressed():
	pass # Replace with function body.
	nextLevel(Globals.difficulty_)


