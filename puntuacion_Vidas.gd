extends Node2D

var puntuacion = 0
var vida: int = 3

func iniciar_juego():
	vida = 200
	puntuacion = 0

func bajarVidas():
	vida -= 1
	if vida <=0:
		reiniciar()
	pass

func subirPuntuacion():
	puntuacion+=1
	pass

func reiniciar():
	iniciar_juego()
	pass
