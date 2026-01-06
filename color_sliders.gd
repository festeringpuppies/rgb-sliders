extends VBoxContainer

const SF: float = 255.0

var current_color: Color = Color.REBECCA_PURPLE

var red_stylebox: StyleBox
var red_stylebox_texture: Texture
var red_st_gradient: Gradient

var green_stylebox: StyleBox
var green_stylebox_texture: Texture
var green_st_gradient: Gradient

var blue_stylebox: StyleBox
var blue_stylebox_texture: Texture
var blue_st_gradient: Gradient

var suppress_signals: bool = true

signal color_changed(val:Color)

func _ready() -> void:
	%red_slider.value_changed.connect(_on_value_changed.bind(0))
	%green_slider.value_changed.connect(_on_value_changed.bind(1))
	%blue_slider.value_changed.connect(_on_value_changed.bind(2))

	%red_slider.value = current_color.r * SF
	%green_slider.value = current_color.g * SF
	%blue_slider.value = current_color.b * SF

	red_stylebox = %red_slider.get_theme_stylebox("slider").duplicate()
	green_stylebox = %green_slider.get_theme_stylebox("slider").duplicate()
	blue_stylebox = %blue_slider.get_theme_stylebox("slider").duplicate()
	
	red_stylebox_texture = red_stylebox.texture.duplicate()
	red_st_gradient = red_stylebox_texture.gradient.duplicate()
	green_stylebox_texture = green_stylebox.texture.duplicate()
	green_st_gradient = green_stylebox_texture.gradient.duplicate()
	blue_stylebox_texture = blue_stylebox.texture.duplicate()
	blue_st_gradient = blue_stylebox_texture.gradient.duplicate()
	
	suppress_signals = false
	update_styleboxes()

func _on_value_changed(value:float, channel:int) -> void:
	if suppress_signals:
		return
		
	match channel:
		0: current_color.r = value/SF
		1: current_color.g = value/SF
		2: current_color.b = value/SF
		
	update_styleboxes()
	color_changed.emit(current_color)
	
func update_styleboxes() -> void:
	red_st_gradient.colors = PackedColorArray([
		Color(0, current_color.g, current_color.b, 1),
		Color(1, current_color.g, current_color.b, 1)])
	red_stylebox_texture.gradient = red_st_gradient
	red_stylebox.texture = red_stylebox_texture
	
	green_st_gradient.colors = PackedColorArray([
		Color(current_color.r, 0, current_color.b, 1),
		Color(current_color.r, 1, current_color.b, 1)])
	green_stylebox_texture.gradient = green_st_gradient
	green_stylebox.texture = green_stylebox_texture
	
	blue_st_gradient.colors = PackedColorArray([
		Color(current_color.r, current_color.g, 0, 1),
		Color(current_color.r, current_color.g, 1, 1)])
	blue_stylebox_texture.gradient = blue_st_gradient
	blue_stylebox.texture = blue_stylebox_texture
	
	%red_slider.add_theme_stylebox_override("slider", red_stylebox)
	%green_slider.add_theme_stylebox_override("slider", green_stylebox)
	%blue_slider.add_theme_stylebox_override("slider", blue_stylebox)

func set_initial_color(x: Color) -> void:
	current_color = x
	%red_slider.value = current_color.r * SF
	%green_slider.value = current_color.g * SF
	%blue_slider.value = current_color.b * SF
	update_styleboxes()
