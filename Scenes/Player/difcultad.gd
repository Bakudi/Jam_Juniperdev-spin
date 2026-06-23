extends Node
@onready var logica = get_node("..")

var facil_1 = ["J","I","L"]
var facil_2 = ["Q","B","P"]
var medio_1 = ["D","W","A","S"]
var medio_2 = ["A","X","K","U"]
var dificil_1 = ["S","X","C","F","E"]
var dificil_2 = ["G","B","N","J","Y"]
var emputado_1 = ["Q","S","C","M","H","T"]
var emputado_2 = ["S","C","V","K","U","Y"]
#
var array_facil = [facil_1, facil_2]
var array_Medio = [facil_1, facil_2, medio_1,medio_2]
var array_dificil = [medio_1, medio_2,dificil_1,dificil_2]
var array_emputado = [dificil_1, dificil_2, emputado_1, emputado_2]
var arreglo_envio = []
var devolver_dificultad: int


func definir_dificultad():
	if PuntuacionVidas.puntuacion < 3:
		arreglo_envio = array_facil
		return arreglo_envio
	elif PuntuacionVidas.puntuacion >= 3 and PuntuacionVidas.puntuacion < 6:
		arreglo_envio = array_Medio
		return arreglo_envio
	elif PuntuacionVidas.puntuacion >= 6 and PuntuacionVidas.puntuacion < 8:
		arreglo_envio = array_dificil
		return arreglo_envio
	elif PuntuacionVidas.puntuacion >= 8:
		arreglo_envio = array_emputado
		return arreglo_envio
		
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
