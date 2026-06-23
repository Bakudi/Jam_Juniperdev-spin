extends Node2D

@onready var script_dif = $"Node2D-hijo"
@onready var animacion_inicio: AnimatedSprite2D = $AnimatedSprite2D

const NIVELES = [
	preload("res://Scenes/Levels/beyblade.tscn"),
	preload("res://Scenes/Levels/bruja.tscn"),
	preload("res://Scenes/Levels/niño_gato.tscn"),
	preload("res://Scenes/Levels/spinner.tscn"),
	preload("res://Scenes/Levels/ventilador.tscn")
]

var random_start: int
var input_registrado: bool = false
var arreglo_utilizado: Array = []
var nivel_actual_instancia: Node = null
var nivel_actual_index: int = -1

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
	
	$Input_Timer.stop()
	$Global_Timer.stop()
	$Input_Timer.wait_time = randf_range(3, 5)
	$Global_Timer.wait_time = $Input_Timer.wait_time * 3 + 1
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
	
	if Input.is_action_just_pressed("Iniciar"):
		_iniciar_con_animacion()

	if $Global_Timer.time_left <= 0:
		return
	
	var en_ventana: bool = $Input_Timer.time_left > 0

	for tecla in arreglo_utilizado:
		if Input.is_action_just_pressed(tecla):
			if en_ventana and not input_registrado and tecla == arreglo_utilizado[random_start]:
				input_registrado = true
				PuntuacionVidas.subirPuntuacion()
				print("le dio bien — puntos: ", PuntuacionVidas.puntuacion)
			else:
				if not input_registrado:
					perder_vida()
					return

func _iniciar_con_animacion() -> void:
	animacion_inicio.play("idle")
	await animacion_inicio.animation_finished
	nivel_actual_instancia.get_node("AnimatedSprite2D").play("idle")
	$Global_Timer.start()
	$Input_Timer.start()
	
func perder_vida():
	PuntuacionVidas.bajarVidas()
	print("vida perdida — vidas: ", PuntuacionVidas.vida)
	crear_nivel()
	
func _on_input_timer_timeout() -> void:
	if not input_registrado:
		perder_vida()
		return
		input_registrado = false
	if random_start >= arreglo_utilizado.size() - 1:
		random_start = 0
	else:
		random_start += 1

func _on_global_timer_timeout() -> void:
	$Input_Timer.stop()
	crear_nivel()
