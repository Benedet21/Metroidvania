extends KinematicBody2D

var dead = false;
var vida = 3
var flip = true
var posicao_inicial
var posicao_final
var velocidade = 0.1

func _ready():
	$AnimatedSprite.play("andar")
	posicao_inicial = $".".position.x
	posicao_final = posicao_inicial + 100

func _process(delta):

	if(posicao_inicial <= posicao_final and flip):
		$".".position.x += velocidade
		$AnimatedSprite.flip_h = false
		if($".".position.x >= posicao_final):
			flip = false
	if($".".position.x >= posicao_inicial and !flip):
		$".".position.x -= velocidade
		$AnimatedSprite.flip_h = true
		if($".".position.x <= posicao_inicial):
			flip = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("espada"):
		velocidade = 0
		vida -= 1
		$AnimatedSprite.play("dano")
	if vida < 1:
		velocidade = 0
		dead = true;
		$AnimatedSprite.play("morte");
		
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "morte":
		queue_free();
