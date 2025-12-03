extends CharacterBody2D

const HAUT = Vector2(0, -1)
const SAUTER = 200
const VITESSECHUTE = 200
const GRAVITE = 10

var mouvement = Vector2()
var Mur = preload("res://wallnode.tscn") # Précharge la scène du mur pour la réutiliser
var score = 0
func _physics_process(delta): 
	mouvement.y += GRAVITE
	if mouvement.y > VITESSECHUTE:
		mouvement.y = VITESSECHUTE
	
	if Input.is_action_just_pressed("SAUTER"): 
		mouvement.y = -SAUTER 
	velocity = mouvement   # on copie le vecteur dans velocity intégré
	move_and_slide()      
	mouvement = velocity   # on récupère le résultat du déplacement
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)
# Met à jour le texte du score à l’écran (dans le CanvasLayer)

func mur_reinitialisation():
	var mur_instance = Mur.instantiate()
	mur_instance.position = Vector2(450, randf_range(-60, 60))
	get_parent().call_deferred("add_child", mur_instance)
# Ajoute le mur à la scène après la frame courante (pour éviter les conflits de modification)

# Appelé quand un  mur entre en collision avec le resetter (limite gauche de l’écran)
func _on_resetter_body_entered(body: Node2D) -> void:
	if body.name == "Walls":
		body.queue_free()       # Supprime le mur actuel
		mur_reinitialisation()  # Crée un nouveau mur
	

# Appelé quand une zone détecte une entrée (par example le joueur traverse une zone de points)
func _on_capteur_area_entered(area: Area2D) -> void:
	if area.name == "PointArea":
		score=score+1


func _on_capteur_body_entered(body: Node2D) -> void:
	if body.name == "Walls":
		get_tree().reload_current_scene()
