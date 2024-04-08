class_name Actor
extends CharacterBody2D

# Maintain a reference to the current controller
var controller: ActorController

# Reference to the container that will contain the controller node
@onready var controller_container = $ControllerContainer

# By default, we create a ActorController
func _ready() -> void:
	set_controller(ActorController.new(self))
	

# We added this method to allow changing the active controller
func set_controller(in_controller: ActorController) -> void:
	# Delete all previous controllers
	for child in controller_container.get_children():
		child.queue_free()

	controller = in_controller
	controller_container.add_child(controller)
