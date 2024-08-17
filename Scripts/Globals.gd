extends Node
### VARIABLES ###
var savePath = "user://schwieirgMem_save.txt"

var difficulty_ : float = 1.0
var perfectScore : int

var currentSet_play : Array = []

var numWordsToTest : int = 2

var cSet1 : Array
var cSet2 : Array
var cSet3 : Array
var setPhy : Array = ["Newton", "Einstein", "Pascal", "Hooke"]
var setMam : Array = ["Calculus", "Integrals", "Derivative", "Linear differential equation", "Optimisation"]
var setCS : Array = ["Selection", "Iteration", "String", "Array", " Function", "Recursion"]

var cExternalSet : Array

### FUNCTIONS ###
func _ready():
	pass
	load_score() # automatically load data when game starts


func _process(delta):
	pass


func clearSets():
	cSet1 = []
	cSet2 = []
	cSet3 = []
	difficulty_ = 1.0
	perfectScore = 0
	save_score()

## SAVE & LOAD
func save_score():
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	
	# custom sets
	file.store_var(cSet1)
	file.store_var(cSet2)
	file.store_var(cSet3)
	
	# predefined sets
	file.store_var(setPhy)
	file.store_var(setMam)
	file.store_var(setCS)
	
	# scores
	file.store_var(difficulty_)
	file.store_var(perfectScore)


func load_score():
	# to opem save file go to:
	# C:\Users\"username"\AppData\Roaming\Godot\app_userdata\Schwierig Memorization
	if FileAccess.file_exists(savePath):
		print("file found")
		var file = FileAccess.open(savePath, FileAccess.READ)

		cSet1 = file.get_var()
		cSet2 = file.get_var()
		cSet3 = file.get_var()
		
		setPhy = file.get_var()
		setMam = file.get_var()
		setCS = file.get_var()
		
		difficulty_ = file.get_var()
		perfectScore = file.get_var()
		
		# trace prints
		#print(cSet1, "= cSet1 after loading")
		#print(cSet2, "= cSet2 after loading")
		#print(cSet3, "= cSet3 after loading")
	else:
		print("file not found")
		cSet1 = []
		cSet2 = []
		cSet3 = []
		
		setPhy  = ["Newton", "Einstein", "Pascal", "Hooke"]
		setMam = ["Calculus", "Integrals", "Derivative", "Linear differential equation", "Optimisation"]
		setCS = ["Selection", "Iteration", "String", "Array", " Function", "Recursion"]
		
		difficulty_ = 1.5
		perfectScore = 0
		#highscore = 0

func openDataFolder():
	pass
	var dataPath = OS.get_data_dir()
	dataPath += str("/Godot/app_userdata/Schwierig Memorization") # 
	
	OS.shell_open(dataPath)
