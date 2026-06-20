extends Node2D
@onready var script_dif = $"Node2D-hijo"
var vida: int = 3
var dificultad: int
var puntuacion = 12
var teclas_faciles = ["Q", "B", "P"]
var random_three: int
var input_registrado: bool = false
var arreglo_utilizado: Array = []
var mismoNivel : bool = false

func _ready():
	
	random_three = randi_range(0, 2)
	script_dif.definir_dificultad()
	var random_array = randi_range(0, script_dif.arreglo_envio.size())
	arreglo_utilizado = script_dif.arreglo_envio[random_array]
	print(arreglo_utilizado)
	print(random_three)

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Iniciar"):
		
		if !mismoNivel:
			$Input_Timer.wait_time = randf_range(0.9, 1.5)
			$Global_Timer.wait_time = $Input_Timer.wait_time * 3 + 1
			
			#Hace la animación antes de empezar el timer
			#animation_player.play("tu_animacion_de_intro")
			#await animation_player.animation_finished
			mismoNivel = true
			$Global_Timer.start()
			$Input_Timer.start()
			
		
	if $Global_Timer.time_left <= 0:
		return
	
	#Ventana de darle al botón
	var en_ventana: bool = $Input_Timer.time_left > 0
	
	for tecla in teclas_faciles:
		if Input.is_action_just_pressed(tecla):
			if en_ventana and not input_registrado and tecla == teclas_faciles[random_three]:
				input_registrado = true
				puntuacion += 1
				print("le dio bien")
			else:
				if not input_registrado:
					vida -= 1
					print("tecla incorrecta o a destiempo — vidas: ", vida)
					if vida == 0:
						print("perdiste mano")
						get_tree().reload_current_scene()
						return

func _on_input_timer_timeout() -> void:
	if not input_registrado:
		vida -= 1
		print("no presionó — vidas: ", vida)
		if vida == 0:
			print("perdiste mano")
			get_tree().reload_current_scene()
			return
	input_registrado = false
	if random_three >= 2:
		print("reinicio del random_three")
		random_three = 0
		print(random_three)
	else:
		print("suma del random")
		random_three += 1
		print(random_three)
		
