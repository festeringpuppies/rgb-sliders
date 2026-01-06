@tool
class_name SliderPanelDeluxe
extends PanelContainer

@export_enum("normal", "focused") var active_style: String = "normal":
	set(new_val):
		active_style = new_val
		_set_style(active_style)

@export var normal_style: StyleBox = preload("res://slider_panel_normal.tres")
@export var focused_style: StyleBox = preload("res://slider_panel_focused.tres")
@export var the_slider: Slider

func _ready() -> void:
	_set_style("normal")
	if the_slider:
		the_slider.editable = false
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	the_slider.mouse_exited.connect(_on_slider_mouse_exited)

	# NOTE: The following focus & mouse settings need to be set either
	# here or in the editor:
	# slider: focus -- (all, inherited); mouse -- (pass, inherited)
	# panel: focus -- (all, inherited); mouse -- (stop, inherited)
	the_slider.mouse_filter = Control.MOUSE_FILTER_PASS
	the_slider.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
	the_slider.focus_mode = Control.FOCUS_ALL
	the_slider.focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED

	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
	focus_mode = Control.FOCUS_ALL
	focus_behavior_recursive = Control.FOCUS_BEHAVIOR_INHERITED

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_set_style(active_style)
	
func _input(event: InputEvent) -> void:
	if not has_focus() and not the_slider.has_focus():
		return
		
	if has_focus():
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
			the_slider.editable = not the_slider.editable

	elif the_slider.has_focus() or the_slider.editable:
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
			get_viewport().set_input_as_handled()
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
			if the_slider.editable:
				the_slider.editable = false
				
	if the_slider.editable:
		the_slider.grab_focus()
	else:
		grab_focus()

func _on_slider_mouse_exited() -> void:
	grab_focus()
	
func _on_mouse_entered() -> void:
	the_slider.editable = true
	
func _on_mouse_exited() -> void:
	the_slider.editable = false
	
func _on_focus_entered() -> void:
	_set_style("focused")
	
func _on_focus_exited() -> void:
	_set_style("normal")
	
func _set_style(yeah:String) -> void:
	var the_box: StyleBox = normal_style
	if yeah=="focused":
		the_box = focused_style
	if the_box!=null:
		add_theme_stylebox_override("panel", the_box)
		
