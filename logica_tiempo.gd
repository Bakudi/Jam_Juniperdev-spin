extends Node2D
var vida: int = 3
var dificultad: int
var puntuacion = 0
var teclas_faciles = ["Q", "B", "P"]
var random_three: int
var input_registrado: bool = false

func _ready():
	random_three = randi_range(0, 2)
	print(random_three)

func _process(delta: float) -> void:
	if $Global_Timer.time_left <= 0:
		return
	
	var en_ventana: bool = $Input_Timer.time_left < 1.5 and $Input_Timer.time_left > 0
	
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
		
