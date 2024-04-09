class_name Actor
extends CharacterBody2D


var controller: ActorController

@onready var controller_container = $ControllerContainer


func _ready() -> void:
	set_controller(ActorController.new(self))


func set_controller(in_controller: ActorController) -> void:
	for child in controller_container.get_children():
		child.queue_free()

	controller = in_controller
	controller_container.add_child(controller)
