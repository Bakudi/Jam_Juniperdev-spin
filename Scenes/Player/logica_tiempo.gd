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

var random_start: int
var input_registrado: bool = false
var arreglo_utilizado: Array = []
var nivel_actual_instancia: Node = null
var nivel_actual_index: int = -1
var randomStart_Await: int
var audio_actual

var duracion_original: float
var niveles_restantes: Array = []

func _ready():
	PuntuacionVidas.reiniciar()
	fill_shuffled()
	crear_nivel()

func fill_shuffled():
	niveles_restantes = range(NIVELES.size())
	niveles_restantes.shuffle()

func crear_nivel():
	if niveles_restantes.is_empty():
		fill_shuffled()
	
	randomStart_Await= randi_range(1,1.5)
	$Input_Timer.stop()
	$Global_Timer.stop()
	$Input_Timer.wait_time = randf_range(1, 1.5)
	$Global_Timer.wait_time = ($Input_Timer.wait_time + randomStart_Await)*3 
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

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Iniciar") and $Global_Timer.time_left <= 0:
		_iniciar_con_animacion()

	if $Global_Timer.time_left <= 0:
		return
	print(arreglo_utilizado,random_start)
	var en_ventana: bool = $Input_Timer.time_left > 0
	#Avisar la tecla a la persona - Pendiente
	for tecla in arreglo_utilizado:
		if Input.is_action_just_pressed(tecla):
			if en_ventana and not input_registrado and tecla == arreglo_utilizado[random_start]:
				input_registrado = true
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("bien")
				await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
				nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
				
			else:
				if not input_registrado:
					input_registrado = true
					nivel_actual_instancia.get_node("AnimatedSprite2D").play("mal")
					await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
					nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
					perder_vida()
					

#func _iniciar_con_animacion() -> void:
	#animacion_inicio.visible = true
	#animacion_inicio.play("idle")
	#await animacion_inicio.animation_finished
	#animacion_inicio.visible = false
	#nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
	#$Global_Timer.start()
	#await get_tree().create_timer(1).timeout
	#audio_actual = audios[nivel_actual_index]
	#var duracion_deseada: float = $Input_Timer.wait_time
	#var duracion_original: float = audio_actual.stream.get_length()
	#var nueva_velocidad: float = duracion_original / duracion_deseada
	#audio_actual.pitch_scale = nueva_velocidad
	#audio_actual.play()
	#$Input_Timer.start()
	
func _iniciar_con_animacion() -> void:
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
	
	# 1. Modificamos la velocidad física del audio
	audio_actual.pitch_scale = nueva_velocidad
	
	# 2. Corregimos el tono usando el efecto del bus personalizado
	var bus_index = AudioServer.get_bus_index("PitchShift")
	var efecto_pitch = AudioServer.get_bus_effect(bus_index, 0)
	efecto_pitch.pitch_scale = 1.0 / nueva_velocidad
	
	# 3. Le damos play al audio y al timer
	print("sonido de inicio del juego")
	audio_actual.play()
	$Input_Timer.start()
	
func perder_vida():
	PuntuacionVidas.bajarVidas()
	print("vida perdida — vidas: ", PuntuacionVidas.vida)
	if PuntuacionVidas.vida <=0:
		nivel_actual_instancia.get_node("AnimatedSprite2D").play("pierde")
		await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_input_timer_timeout() -> void:
	if $Global_Timer.time_left > 0 and $Global_Timer.time_left-$Input_Timer.time_left >= 0:
		if not input_registrado:
			perder_vida()
			print("Perdió vida no presionó")
			nivel_actual_instancia.get_node("AnimatedSprite2D").play("mal")
			await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
			
			# Verificar que el nodo sigue vivo antes de continuar
			if not is_inside_tree():
				return
				
			input_registrado = false
			nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
			await get_tree().create_timer(randomStart_Await).timeout
			
			if not is_inside_tree():
				return
				
			sum_randomStart()
			print("sonido cuando no le da")
			audio_actual.play()
			$Input_Timer.start()
			return
			
		sum_randomStart()
		input_registrado = false
		await get_tree().create_timer(randomStart_Await).timeout
		
		#Mismo chequeo en el flujo normal
		if not is_inside_tree():
			return
		print("sonido cuando si le da")
		$Input_Timer.start()
		audio_actual.play()
		

func sum_randomStart():
	if random_start >= arreglo_utilizado.size() - 1:
		random_start = 0
	else:
		random_start += 1

func _on_global_timer_timeout() -> void:
	$Input_Timer.stop()
	audio_actual.stop()
	PuntuacionVidas.subirPuntuacion()
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("gana")
	await nivel_actual_instancia.get_node("AnimatedSprite2D").animation_finished
	crear_nivel()
