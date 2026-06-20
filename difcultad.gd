extends Node
@onready
var logica = get_node("res://logica_tiempo.gd") 

var facil_1 = ["J","I","L"]
var facil_2 = ["Q","B","P"]
var medio_1 = ["D","W","A","S"]
var medio_2 = ["A","X","K","U"]
var dificil_1 = ["S","X","C","F","E"]
var dificil_2 = ["G","B","N","J","Y"]
var emputado_1 = ["Q","S","C","M","H","T"]
var emputado_2 = ["S","C","V","K","U","Y"]
var devolver_dificultad: int

func Dificultad():
	logica.puntuacion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
