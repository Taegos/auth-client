extends Panel

const _PORT : int = 9001
const _IP : String = "127.0.0.1"

func _ready():
	_center_window()
	
func _center_window():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
