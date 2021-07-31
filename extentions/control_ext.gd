
static func enable_children(var current: Control, var enabled: bool):
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
			enable_children(child, enabled)
