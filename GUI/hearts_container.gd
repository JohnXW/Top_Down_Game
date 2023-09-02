extends HBoxContainer

@onready var heartGUIClass = preload("res://GUI/heart_gui.tscn")
var heart
var hearts
var numberOfFullHearts:int = 0
var numberOfFullEmptyHearts:int = 0
var unfullHeart: int = 0

func setMaxHearts(max: int):
	for i in range(max/4):
		heart = heartGUIClass.instantiate()
		add_child(heart)
	if max % 4 != 0:
		heart = heartGUIClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	hearts = get_children() #for finding out number of total hearts
	numberOfFullHearts = currentHealth/4 # finding out number of full hp hearts
	numberOfFullEmptyHearts = (PlayerVariables.maxHP - currentHealth)/4
	unfullHeart = currentHealth%4 # to get fraction of heart

	for i in numberOfFullHearts: #update all full hearts
			hearts[i].update(4)
	if unfullHeart == 0: #check for fraction
		for i in range (numberOfFullHearts, hearts.size()):
			hearts[i].update(0)
	else:
		hearts[numberOfFullHearts].update(unfullHeart)
		for i in range (numberOfFullHearts+1, hearts.size()):
			hearts[i].update(0)
