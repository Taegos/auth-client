extends Panel

const LoginForm = preload("res://scenes/login_form.tscn")
const CreateAccountForm = preload("res://scenes/create_account_form.tscn")

func _ready():
	_center_window()
	_create_login_form()
	
func _center_window():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	_enter_game("")


func _enter_game(token: String):
	OS.alert(
		'The authentication was successful.\n' +
		'Token: ' + str(token) + '\n' +
		'Now this window should exit and the main game client should start '  +
		'with the received token (Not implemented).',
		'(Placeholder)')

	#get_tree().change_scene("res://scenes/game.tscn")
	
	
	print("asd")
	#$GS.start_verification(token)

#remote func get_token():
#	rpc_id(1, "sync_token", _token)

func _create_login_form():
	add_child(LoginForm.instance())
	$LoginForm.connect("on_submit", $API, "authenticate")
	$LoginForm/ButtonBox/CreateAccountButton.connect("button_down", self, "_show_create_acc_form")
	$API.connect("on_auth_succeeded", self, "_on_auth_succeeded")
	$API.connect("on_auth_failed", $LoginForm, "display_error")	

func _show_login_form():
	$CreateAccountForm.queue_free()
	_create_login_form()
	
func _on_auth_succeeded(token: String):
	_enter_game(token)
	
func _show_create_acc_form():
	$LoginForm.queue_free()
	add_child(CreateAccountForm.instance())
	$CreateAccountForm.connect("on_submit", $API, "create_account")
	$CreateAccountForm/ButtonBox/GoBackButton.connect("button_down", self, "_show_login_form")
	$API.connect("on_create_acc_succeeded", self, "_on_create_acc_succeeded")
	$API.connect("on_create_acc_failed", $CreateAccountForm, "display_error")	
	
func _on_create_acc_succeeded(token: String):
	_enter_game(token)
