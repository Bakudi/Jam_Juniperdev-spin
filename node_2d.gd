extends Node2D

var vida :int = 3

var teclas_faciles : Array[String] = ["Q", "B", "P"]
var random_three : int

func _ready():
	
	random_three = randi_range(0, 2)
	print(random_three)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	while($Global_Timer.time_left > 0):
		if($Input_Timer.time_left < 1.5 and $Input_Timer.time_left > 0):
			if(Input.is_action_just_pressed(teclas_faciles[random_three])):
				print("le dio bien")
			else:
				vida -= 1
				if( vida == 0):
					print("perdiste mano")
					$Global_Timer.stop()
			if(random_three >= 2):
				print("reinicio del random_three")
				random_three = 0
			else:
				print("suma del random")
				random_three +=1
	#Critico
	#if($Input_Timer.time_left < 1.5 and $Input_Timer.time_left > 0):
			#print("alo")
		#else:
			#if($Input_Timer.time_left == 0):
				#vida -=1
	pass

func _on_input_timer_timeout() -> void:
	pass # Replace with function body.
