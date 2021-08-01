extends Node

##############
# Signals
##############
signal on_auth_succeeded(token)
signal on_auth_failed(reason)
signal on_create_acc_succeeded(token)
signal on_create_acc_failed(reason)

##############
# Variables
##############
var endpoint : String = ""

func _ready():
	var config = ConfigFile.new()
	var status = config.load("res://config.cfg")
	if status != OK:
		OS.alert("Failed to load config.cfg", "Error")
		get_tree().quit()
		
	endpoint = config.get_value("server", "endpoint")
	$Authenticate.connect("request_completed", self, "_on_auth_req_completed")
	$CreateAccount.connect("request_completed", self, "_on_create_acc_req_completed")

func _on_auth_req_completed(result: int, code: int, 
						   headers: PoolStringArray, body: PoolByteArray):
	var content : String = body.get_string_from_utf8()
	if result != HTTPRequest.RESULT_SUCCESS || code != 201:
		emit_signal("on_auth_failed", content)
	else:
		emit_signal("on_auth_succeeded", content)

func _on_create_acc_req_completed(result: int, code: int, 
						   headers: PoolStringArray, body: PoolByteArray):
	var content : String = body.get_string_from_utf8()
	if result != HTTPRequest.RESULT_SUCCESS || code != 201:
		emit_signal("on_create_acc_failed", content)
	else:
		emit_signal("on_create_acc_succeeded", content)

func authenticate(account: Dictionary):
	var query = JSON.print(account)
	var headers : PoolStringArray = [
		"Content-Type: application/json"
	]
	var code = $Authenticate.request(
		endpoint + "auth", 
		headers, false, 
		HTTPClient.METHOD_POST, 
		query
	)
	
	if code != OK:
		emit_signal("on_auth_failed", "An error occurred in the HTTP request.")


func create_account(account: Dictionary):
	var query = JSON.print(account)
	var headers : PoolStringArray = [
		"Content-Type: application/json"
	]
	
	var code = $CreateAccount.request(
		endpoint + "account", 
		headers, false, 
		HTTPClient.METHOD_POST, 
		query
	)
	if code != OK:
		emit_signal("on_create_acc_failed", "An error occurred in the HTTP request.")
