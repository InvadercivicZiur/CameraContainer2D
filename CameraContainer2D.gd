extends Node2D
class_name CameraContainer2D, 'res://CameraContainer2D.svg'
tool


var camera_target = null


"""
HOW TO USE
func _ready() -> void:
	$CameraContainer2D.set_camera_target('/root/Level_1/Shadow/PlayerSprite/Position2D', Vector2(Tween.TRANS_CUBIC, Tween.EASE_IN_OUT), 3)
"""


func _ready() -> void:
	self.add_child(Tween.new(), true)


func _get_configuration_warning():
	
	if self.has_node('Camera2D') == false:
		return 'Add a Camera2D'
	
	return ''



func _process(delta: float) -> void:
	if Engine.editor_hint == false:
		_follow_target()



func _follow_target():
	if camera_target != null:
		self.global_position = camera_target.global_position




func set_camera_target(new_target: NodePath, transition_types: Vector2, speed_of_transition: float):
	camera_target = null
	
	if new_target != null:
		
		get_node('Tween').interpolate_property(
			self, 'position', self.global_position,
			get_node(new_target).global_position,
			speed_of_transition, transition_types.x, transition_types.y)
		
		get_node('Tween').start()
		
		yield(get_node('Tween'), 'tween_completed')
		
		camera_target = get_node(new_target)
