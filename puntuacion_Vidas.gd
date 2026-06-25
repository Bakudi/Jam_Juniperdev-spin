extends Node2D

var puntuacion = 0
var vida: int = 3

func iniciar_juego():
	vida = 3
	puntuacion = 0

func bajarVidas():
	vida -= 1
	pass

func subirPuntuacion():
	puntuacion+=1
	pass

func reiniciar():
	iniciar_juego()
	pass
