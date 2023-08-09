extends Camera2D

@export var tileMap: TileMap
# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRect = tileMap.get_used_rect()
	var tileSize = tileMap.cell_quadrant_size
	var worldSizePixels = mapRect.size * tileSize
	limit_right = worldSizePixels.x - 2*tileSize
	limit_bottom = worldSizePixels.y - 2*tileSize
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
