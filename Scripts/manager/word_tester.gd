extends Control
### VARIABLES

@export_range(0.1,2.0) var loadSpeed : float = 1.0

@export var wordList_tst : Array = ["Physics", "Math", "Computer Science"]

@onready var txtHold = $Screen/txtScreen

var currentList
var currentLvl = 1
var IND_list = 0 # index for the current

var canType : bool = false
#var loadSpeed : float= 1.0

### FUNCTIONS
func _ready():
	pass
	#introProcedure()	
	currentList = wordList_tst # test
	mainLoop()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if Input.is_key_pressed(KEY_ENTER):
		var txt_ = $input/box/text.text 
		
		addText(txt_)
		
		#$input/box/existWords/Panel/currentTXT.text += txt_
		IND_list += 1
		
		
		if checkText(txt_,currentList,IND_list):
			pass
			$input/box/existWords/Panel/currentTXT.text += txt_
			displayRes(true)
			#IND_list += 1
		else:
			pass
			displayRes(false)



func mainLoop():
	pass
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
	

func showText(list_:Array):
	pass
	for i in list_:
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
	#$input/box/existWords/Panel/currentTXT.text += text_ + "; "
	$input/box/text.clear()
	$input/box/text.text = "..."
	
	#checkText(userText,currentList)

func checkText(word,list,listInd):
	pass
	if word == list[listInd]:
		return true
	else:
		return false

func displayRes(Correct:bool): # display the result
	pass
	if Correct:
		pass
	else:
		pass
