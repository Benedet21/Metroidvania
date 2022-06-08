extends KinematicBody2D

func _on_Epinho_Area_body_entered(body):
	if body.get("TYPE") == "player":
		get_tree().change_scene("res://menu.tscn")
