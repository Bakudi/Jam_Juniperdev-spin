extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Musica.play_music_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Player/node_2d.tscn")


func _on_configuraciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Opciones.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
