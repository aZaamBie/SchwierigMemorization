extends Node

var savePath = "user://schwieirgMem_save.txt"
#var savePath_2 = "C://Users/name/Downloads"

var difficulty_ : float = 1.0
var perfectScore : int

var currentSet_play : Array = []

var cSet1 : Array
var cSet2 : Array
var cSet3 : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#if perfectScore == TYPE_NIL:
		#perfectScore = 0
	load_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func clearSets():
	cSet1 = []
	cSet2 = []
	cSet3 = []
	
	save_score()

## SAVE & LOAD
func save_score():
	var file = FileAccess.open(savePath, FileAccess.WRITE)

	file.store_var(cSet1)
	file.store_var(cSet2)
	file.store_var(cSet3)
	
	file.store_var(difficulty_)
	file.store_var(perfectScore)
	
	#var docs = OS.get_environment("HOME")# + "/Documents"
	#if docs == "":
		#pass
		##docs = OS.get_environment("Documents")
		#docs = OS.get_environment("USERPROFILE")
		#print(docs)

func load_score():
	if FileAccess.file_exists(savePath):
		print("file found")
		var file = FileAccess.open(savePath, FileAccess.READ)
		#highscore = file.get_var()
		cSet1 = file.get_var()
		cSet2 = file.get_var()
		cSet3 = file.get_var()
		
		difficulty_ = file.get_var()
		perfectScore = file.get_var()
		
		print(cSet1, "after loading")
		print(cSet2, "after loading")
		print(cSet3, "after loading")
	else:
		print("file not found")
		cSet1 = []
		cSet2 = []
		cSet3 = []
		
		difficulty_ = 1.0
		perfectScore = 0
		#highscore = 0
