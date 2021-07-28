extends VBoxContainer

############################
# Constants
############################

const EXAMPLE_USER : bool = true

############################
# Signals
############################

signal on_create_account(email, password)

############################
# Public functions
############################

############################
# Remote functions
############################

remote func account_created_ok_response():
	_enable_form(self, true)
	_set_success("Account created successfully")
	
remote func account_created_fail_response(var reason: String):
	_enable_form(self, true)
	_set_error(reason)

############################
# Private functions
############################

func _ready():
	visible = false
	_setup_connections()
	if EXAMPLE_USER:
		$InputBox/EmailInput.text = "test"
		$InputBox/PasswordInput.text = "12345678"
		$InputBox/ConfirmPasswordInput.text = "12345678"

func _setup_connections():
	$ButtonBox/GoBackButton.connect("button_down", self, "_show_login_form")
	$ButtonBox/CreateAccountButton.connect("button_down", self, "_create_account")

func _show_login_form():
	visible = false
	$"../Login".visible = true

func _create_account():
	_enable_form(self, false)
	
	var email: String = $InputBox/EmailInput.text
	var password: String = $InputBox/PasswordInput.text
	var confirm_password: String = $InputBox/ConfirmPasswordInput.text
	
	if password.length() < 8:
		_set_error("Password has to have a length of atleast 8 characters")
	elif password != confirm_password:
		_set_error("Passwords does not match")
	else:
		var client : NetworkedMultiplayerENet = get_parent().create_auth_client()
		client.connect("connection_failed", self, "_on_connection_failed")
		client.connect("connection_succeeded", self, "_on_connection_succeeded")
		#emit_signal("on_create_account", email, password)

func _on_connection_succeeded():
	#_enable_form(self, true)
	var email: String = $InputBox/EmailInput.text
	var password: String = $InputBox/PasswordInput.text
	rpc_id(1, "create_account", email, password)
	print("send")

func _on_connection_failed():
	_enable_form(self, true)
	_set_error("Connection to auth server failed")

func _enable_form(var current: Node, var enabled: bool):
	for child in current.get_children():
		if child is LineEdit:
			child.editable = enabled
		elif child is BaseButton:
			child.disabled = !enabled
		elif child is Label:
			if enabled:
				child.set("custom_colors/font_color", null)
			else:
				child.add_color_override("font_color", Color.gray)	
		if child.get_child_count() > 0:
			_enable_form(child, enabled)

func _set_error(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.red)	

func _set_success(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.green)	

func _set_info(text: String):
	$InfoLabel.text = text
	$InfoLabel.add_color_override("font_color", Color.white)	
