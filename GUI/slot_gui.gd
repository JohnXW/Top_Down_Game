extends Panel

@onready var backgroundSprite: Sprite2D = $Background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/Item

func update(item:InventoryItems):
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false #dk what this is for
		
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
