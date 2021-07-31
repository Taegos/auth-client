extends Panel

#const API: String = "https://transaticka-auth.herokuapp.com/"
#const ACCOUNT: String = API + "account"
#const AUTH: String = API + "auth"

func _ready():
	_center_window()
	
func _center_window():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func enter_game(token: String):
	OS.alert(
		'The authentication was successful.\n' +
		'Token: ' + token + '\n' +
		'Now this window should exit and the main game client should start '  +
		'with the received token (Not implemented).',
		'(Placeholder)')
	get_tree().quit()
