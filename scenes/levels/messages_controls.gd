extends Control

var playing_move_control_msg: bool = false
var playing_jump_control_msg: bool = false
var playing_eat_control_msg: bool = false

var jump_control_msg_showed: bool = false
var eat_control_msg_showed: bool = false

var fade_in_time: float = 3.0
var showing_time: float = 10.0
var fade_out_time: float = 3.0
var rapid_fading_time: float = 1.0

@onready var move_controls_node: CanvasLayer = $MoveControlsMessage
@onready var jump_controls_node: CanvasLayer = $JumpControlsMessage
@onready var eat_controls_node: CanvasLayer = $EatControlsMessage

func _ready():
	show_move_controls()


func show_move_controls():
	playing_move_control_msg = true
	await move_controls_node.fade_in(fade_in_time)
	await get_tree().create_timer(showing_time, false).timeout
	await move_controls_node.fade_out(fade_out_time)
	playing_move_control_msg = false


func show_jump_controls():
	jump_control_msg_showed = true
	playing_jump_control_msg = true
	await jump_controls_node.fade_in(fade_in_time)
	await get_tree().create_timer(showing_time, false).timeout
	await jump_controls_node.fade_out(fade_out_time)
	playing_jump_control_msg = false


func show_eat_controls():
	eat_control_msg_showed = true
	playing_eat_control_msg = true
	await eat_controls_node.fade_in(fade_in_time)
	await get_tree().create_timer(showing_time, false).timeout
	await eat_controls_node.fade_out(fade_out_time)
	playing_eat_control_msg = false


func _on_jump_msg_area_body_entered(_body):
	if jump_control_msg_showed:
		return
		
	if playing_move_control_msg:
		await move_controls_node.fade_out(rapid_fading_time)
		playing_move_control_msg = false
	show_jump_controls()


func _on_eat_msg_area_body_entered(_body):
	if eat_control_msg_showed:
		return
		
	if playing_jump_control_msg:
		await jump_controls_node.fade_out(rapid_fading_time)
		playing_jump_control_msg = false
	show_eat_controls()
