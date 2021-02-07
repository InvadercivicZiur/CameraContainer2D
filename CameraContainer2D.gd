extends Node2D
class_name CameraContainer2D, 'res://CameraContainer2D.svg'
tool


var camera_target = null
var camera_follow_speed := 0

onready var NCamera = get_node('Camera2D')


"""
HOW TO USE
func _ready() -> void:
	$CameraContainer2D.set_camera_target('/root/Level_1/Shadow/PlayerSprite/Position2D', Vector2(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT), 5, 3)
"""

func _ready() -> void:
	self.add_child(Tween.new(), true)


func _process(delta):
	if Engine.editor_hint:
		update_configuration_warning()
	
	if not Engine.editor_hint:
		_follow_target(delta)


func _get_configuration_warning():
	if not self.has_node('Camera2D'):
		return 'Please add a Camera2D'
	return ''


func set_camera_target(new_target: NodePath, transition_types: Vector2, speed_of_transition: float, follow_speed: float):
	camera_target = null
	
	if new_target != null:
		get_node('Tween').interpolate_property(self, 'position', self.global_position, get_node(new_target).global_position, speed_of_transition, transition_types.x, transition_types.y)
		get_node('Tween').start()
		
		yield(get_node('Tween'), 'tween_completed')
		
		camera_target = get_node(new_target)
		camera_follow_speed = follow_speed


func _follow_target(delta):
	if camera_target != null:
#		self.position = lerp(self.global_position, camera_target.global_position, delta * camera_follow_speed)
		self.global_position = camera_target.global_position

