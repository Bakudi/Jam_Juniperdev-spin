extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var contenedor_teclas: HBoxContainer = $Camera2D/ContenedorTeclas
@onready var label_tecla_activa: Label = $Camera2D/ContenedorTeclas/LabelTeclaActiva

func _ready():
	_mostrar_teclas()

func _mostrar_teclas():
	# Limpia cualquier caja previa
	for hijo in contenedor_teclas.get_children():
		hijo.queue_free()
	
	# Crea una caja por cada tecla del arreglo
	for i in GameState.arreglo_utilizado.size():
		var tecla = GameState.arreglo_utilizado[i]
		
		var panel = PanelContainer.new()
		var label = Label.new()
		label.text = tecla
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		# Resalta la tecla que se debe presionar
		if i == GameState.random_start:
			label.add_theme_color_override("font_color", Color.YELLOW)
			panel.add_theme_stylebox_override("panel", _estilo_resaltado())
		else:
			panel.add_theme_stylebox_override("panel", _estilo_normal())
		
		panel.add_child(label)
		panel.custom_minimum_size = Vector2(60, 60)
		contenedor_teclas.add_child(panel)
	
	# Muestra por separado cuál es la tecla correcta
	label_tecla_activa.text = "Presiona: " + GameState.arreglo_utilizado[GameState.random_start]

func _estilo_normal() -> StyleBoxFlat:
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0.2, 0.2, 0.2)
	estilo.border_width_left = 2
	estilo.border_width_right = 2
	estilo.border_width_top = 2
	estilo.border_width_bottom = 2
	estilo.border_color = Color.WHITE
	estilo.corner_radius_top_left = 6
	estilo.corner_radius_top_right = 6
	estilo.corner_radius_bottom_left = 6
	estilo.corner_radius_bottom_right = 6
	return estilo

func _estilo_resaltado() -> StyleBoxFlat:
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0.5, 0.4, 0.0)
	estilo.border_width_left = 3
	estilo.border_width_right = 3
	estilo.border_width_top = 3
	estilo.border_width_bottom = 3
	estilo.border_color = Color.YELLOW
	estilo.corner_radius_top_left = 6
	estilo.corner_radius_top_right = 6
	estilo.corner_radius_bottom_left = 6
	estilo.corner_radius_bottom_right = 6
	return estilo

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Iniciar"):
		GameState.auto_iniciar = true
		get_tree().change_scene_to_file("res://Scenes/Player/node_2d.tscn")
