extends Node2D

@onready var script_dif = $"Node2D-hijo"
@onready var animacion_inicio: AnimatedSprite2D = $AnimatedSprite2D

const aviso_de_tecla = preload("res://Scenes/Levels/Sounds/PlaceHolder_sound.mp3")

const NIVELES = [
	preload("res://Scenes/Levels/beyblade.tscn"),
	preload("res://Scenes/Levels/bruja.tscn"),
	preload("res://Scenes/Levels/niño_gato.tscn"),
	preload("res://Scenes/Levels/spinner.tscn"),
	preload("res://Scenes/Levels/ventilador.tscn")
]

@onready var audios: Array = [
	$Audio_Beyblade,
	$Audio_Bruja,
	$Audio_gato,
	$Audio_Spinner,
	$Audio_Ventilador
]

@onready var contenedor_teclas: HBoxContainer = $ContenedorTeclas
@onready var label_tecla_activa: Label = $ContenedorTeclas/LabelTeclaActiva

var random_start: int
var input_registrado: bool = false
var arreglo_utilizado: Array = []
var nivel_actual_instancia: Node = null
var nivel_actual_index: int = -1
var randomStart_Await: int
var audio_actual

var duracion_original: float
var niveles_restantes: Array = []

var await_Array: Array = [0.5,1.0,1.5]

func _ready():
	if GameState.auto_iniciar:
		GameState.auto_iniciar = false
		niveles_restantes = GameState.niveles_restantes.duplicate()
		nivel_actual_index = GameState.nivel_index_siguiente
		nivel_actual_instancia = NIVELES[nivel_actual_index].instantiate()
		add_child(nivel_actual_instancia)
		input_registrado = false
		$Input_Timer.wait_time = 0.6
		randomStart_Await = randi_range(1, 2)
		arreglo_utilizado = GameState.arreglo_utilizado.duplicate()
		random_start = GameState.random_start
		$Global_Timer.wait_time = ($Input_Timer.wait_time + randomStart_Await) * arreglo_utilizado.size()*3 + 1
		_iniciar_con_animacion()
		_mostrar_teclas()
		randomStart_Await = 1.21
	else:
		PuntuacionVidas.reiniciar()
		fill_shuffled()
		_preparar_siguiente_nivel()
		get_tree().change_scene_to_file("res://Scenes/EntreTiempo.tscn")

func fill_shuffled():
	niveles_restantes = range(NIVELES.size())
	niveles_restantes.shuffle()

func crear_nivel():
	if niveles_restantes.is_empty():
		fill_shuffled()
	
	$Input_Timer.stop()
	$Global_Timer.stop()
	$Input_Timer.wait_time = 1
	
	var nuevo_index = niveles_restantes.pop_front()
	while nuevo_index == nivel_actual_index:
		nuevo_index = randi_range(0, NIVELES.size() - 1)
	nivel_actual_index = nuevo_index

	if nivel_actual_instancia != null:
		nivel_actual_instancia.queue_free()
	nivel_actual_instancia = NIVELES[nivel_actual_index].instantiate()
	add_child(nivel_actual_instancia)
	
	input_registrado = false
	script_dif.definir_dificultad()
	var random_array = randi_range(0, script_dif.arreglo_envio.size() - 1)
	arreglo_utilizado = script_dif.arreglo_envio[random_array]
	random_start = randi_range(0, arreglo_utilizado.size() - 1)
	print(arreglo_utilizado, random_start)
	$Global_Timer.wait_time = ($Input_Timer.wait_time + randomStart_Await) * arreglo_utilizado.size() + 1

func _mostrar_teclas():
	# Limpia cualquier caja previa
	for hijo in contenedor_teclas.get_children():
		hijo.queue_free()
	
	# Crea una caja por cada tecla del arreglo
	for i in arreglo_utilizado.size():
		var tecla = arreglo_utilizado[i]
		
		var panel = PanelContainer.new()
		var label = Label.new()
		label.text = tecla
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		# Resalta la tecla que se debe presionar
		if i == random_start:
			label.add_theme_color_override("font_color", Color.YELLOW)
			panel.add_theme_stylebox_override("panel", _estilo_resaltado())
		else:
			panel.add_theme_stylebox_override("panel", _estilo_normal())
		
		panel.add_child(label)
		panel.custom_minimum_size = Vector2(60, 60)
		contenedor_teclas.add_child(panel)
	
	# Muestra por separado cuál es la tecla correcta
	#label_tecla_activa.text = "Presiona: " + GameState.arreglo_utilizado[GameState.random_start]

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

func _preparar_siguiente_nivel():
	if niveles_restantes.is_empty():
		fill_shuffled()
	
	var nuevo_index = niveles_restantes.pop_front()
	while nuevo_index == nivel_actual_index:
		nuevo_index = randi_range(0, NIVELES.size() - 1)
	
	script_dif.definir_dificultad()
	var random_array = randi_range(0, script_dif.arreglo_envio.size() - 1)
	var arreglo_siguiente = script_dif.arreglo_envio[random_array]
	var start_siguiente = randi_range(0, arreglo_siguiente.size() - 1)
	
	print("PREPARANDO NIVEL - arreglo: ", arreglo_siguiente, " start: ", start_siguiente)
	
	GameState.nivel_index_siguiente = nuevo_index
	GameState.arreglo_utilizado = arreglo_siguiente.duplicate()
	GameState.random_start = start_siguiente
	GameState.niveles_restantes = niveles_restantes.duplicate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Iniciar") and $Global_Timer.time_left <= 0:
		_iniciar_con_animacion()

	if $Global_Timer.time_left <= 0:
		return

	if input_registrado:
		return

	var en_ventana: bool = $Input_Timer.time_left > 0
	for tecla in arreglo_utilizado:
		if Input.is_action_just_pressed(tecla):
			if en_ventana and tecla == arreglo_utilizado[random_start]:
				input_registrado = true
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("bien")
				await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
			else:
				input_registrado = true
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("mal")
				await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
				print("tecla mala")
				perder_vida()
			break

func _iniciar_con_animacion() -> void:
	Musica.play_music_level("res://Scenes/Levels/Sounds/Sonido_Niveles_corregido.mp3")
	animacion_inicio.visible = true
	animacion_inicio.play("idle")
	await animacion_inicio.animation_finished
	animacion_inicio.visible = false
	
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
	$Global_Timer.start()
	await get_tree().create_timer(1).timeout
	
	audio_actual = audios[nivel_actual_index]
	var duracion_deseada: float = $Input_Timer.wait_time
	var duracion_original: float = audio_actual.stream.get_length()
	var nueva_velocidad: float = duracion_original / duracion_deseada
	
	audio_actual.pitch_scale = nueva_velocidad
	
	var bus_index = AudioServer.get_bus_index("PitchShift")
	var efecto_pitch = AudioServer.get_bus_effect(bus_index, 0)
	efecto_pitch.pitch_scale = 1.0 / nueva_velocidad
	
	print("sonido de inicio del juego")
	audio_actual.play()
	$Input_Timer.start()
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("presionar")
	print(arreglo_utilizado, random_start)

func perder_vida():
	PuntuacionVidas.bajarVidas()
	print("vida perdida — vidas: ", PuntuacionVidas.vida)
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("mal")
	await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
	if PuntuacionVidas.vida <= 0:
		nivel_actual_instancia.get_node("AnimatedSprite2D").play("pierde")
		await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_input_timer_timeout() -> void:
	if $Global_Timer.time_left > 0 and $Global_Timer.time_left - $Input_Timer.time_left >= 0:
		if not input_registrado:
			print("Malparido")
			perder_vida()
			sum_randomStart()
			await get_tree().create_timer(randomStart_Await).timeout
			print(arreglo_utilizado, random_start)
			$Input_Timer.start()
			nivel_actual_instancia.get_node("AnimatedSprite2D").play("presionar")
			audio_actual.play()
			return
		sum_randomStart()
		await get_tree().create_timer(randomStart_Await).timeout
		print("lo cambie")
		input_registrado = false
		print("sonido cuando si le da")
		$Input_Timer.start()
		nivel_actual_instancia.get_node("AnimatedSprite2D").play("presionar")
		audio_actual.play()

func sum_randomStart():
	if random_start >= arreglo_utilizado.size() - 1:
		random_start = 0
		_mostrar_teclas()
	else:
		random_start += 1
		_mostrar_teclas()

func _on_global_timer_timeout() -> void:
	$Input_Timer.stop()
	audio_actual.stop()
	PuntuacionVidas.subirPuntuacion()
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("gana")
	await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
	_preparar_siguiente_nivel()
	get_tree().change_scene_to_file("res://Scenes/EntreTiempo.tscn")
