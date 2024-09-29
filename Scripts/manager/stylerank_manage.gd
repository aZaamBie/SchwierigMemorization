extends Control

@export var animP : AnimationPlayer

var ranks = [0,1,2,3,4,5] # list of ranks
var rank_ = 0 # current rank

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	init_()

func init_():
	pass
	rank_ = 0
	rankState()

func increaseRank():
	rank_ += 1
	rankState()
	
	rank_ = clamp(rank_, 0, len(ranks))
func decreaseRank():
	rank_ -= 1
	rankState()
	
	rank_ = clamp(rank_, 0, len(ranks))
	

func rankState():
	pass
	print(rank_, " is current rank")
	
	match rank_:
		0: # nothing
			pass
			animP.play("none")
		1: # D rank
			pass
			animP.play("D")
		2: # C rank
			pass
			animP.play("C")
		3: # B rank
			pass
			animP.play("B")
		4: # A rank
			pass
			animP.play("A")
		5: # S rank
			pass
		_: # DEFAULT
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
