extends Node2D

@onready var anim_player = $AnimationPlayer

func _process(_delta):
	if Input.is_action_just_pressed("playanimationcharacterattack"):  
		$AnimationPlayer.play("Character_Attack")
	if Input.is_action_just_pressed("playanimationcharacterkill"):  
		$AnimationPlayer.play("Character_Kill")
	if Input.is_action_just_pressed("playanimationenemyattack"):  
		$AnimationPlayer.play("Enemy_Attack")
	if Input.is_action_just_pressed("playanimationenemykill"):  
		$AnimationPlayer.play("Enemy_Kill")
	if Input.is_action_just_pressed("idle"):  
		$AnimationPlayer.play("Idle")
