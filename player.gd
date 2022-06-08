extends KinematicBody2D

const TYPE = "player"
 
const UP = Vector2(0, -1)
const speed = 200
const jumpspeed = -600
const gravity = 30
var player_health = 3
var max_health = 3
var motion = Vector2()
var ataque = false

signal change_life(player_health)

func _ready() -> void:
	connect("change_life", get_parent().get_node("hud/HBoxContainer/Control"), "on_change_life")
	emit_signal("change_life", max_health)

func _physics_process(delta):
	motion.y += gravity

	if Input.is_action_pressed("ui_right") and ataque == false:
		motion.x = speed
		$AnimatedSprite.play("correr")
		$AnimatedSprite.flip_h = false

	elif Input.is_action_pressed("ui_left") and ataque == false:
		motion.x = -speed
		$AnimatedSprite.play("correr")
		$AnimatedSprite.flip_h = true
	else:
		motion.x = 0
		if ataque == false:
			$AnimatedSprite.play("parado")

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"): 
			motion.y = jumpspeed
			$puloSom.play()
			
	else:
		if motion.y <= 0:
			$AnimatedSprite.play("pulo")
		elif motion.y > 0:
			$AnimatedSprite.play("caindo")
		


	motion = move_and_slide(motion, UP)

	if Input.is_action_just_pressed("z") and is_on_floor():
		$ataqueSom.play()
		$AnimatedSprite.play("ataque")
		$areaataque/CollisionShape2D.disabled = false;
		ataque = true;

	if Input.is_action_pressed("ui_right"):
		get_node("areaataque").set_scale(Vector2(1, 1))
	elif Input.is_action_pressed("ui_left"): 
		get_node("areaataque").set_scale(Vector2(-1, 1))

func _on_dano_body_entered(body):
	player_health = player_health - 1
	emit_signal("change_life", player_health)
	$AnimatedSprite.play("levar_dano")
	$danoSom.play()
	if player_health < 1:
		$AnimatedSprite.play("morte")
		get_tree().change_scene("res://menu.tscn")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "ataque":
		$areaataque/CollisionShape2D.disabled = true;
		ataque = false;
		
		
