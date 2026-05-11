class_name DebugRunner
extends Node2D


var level: BaseLevel


func _ready() -> void:
    var level_scene_path := self.consumePathOfSceneToDebug()

    if level_scene_path == "":
        push_error("DebugLevelRunner: No debug level scene path was provided.")
        return

    var level_scene := load(level_scene_path) as PackedScene
    if level_scene == null:
        push_error("DebugLevelRunner: Failed to load level scene: ", level_scene_path)
        return

    self.startLevel(level_scene)


func consumePathOfSceneToDebug() -> String:
    var tree := get_tree()

    if not tree.has_meta("debug_runner__scene_to_launch__path"):
        return ""

    var path := tree.get_meta("debug_runner__scene_to_launch__path") as String
    tree.remove_meta("debug_runner__scene_to_launch__path")

    return path


func startLevel(level_scene: PackedScene) -> void:
    self.level = level_scene.instantiate()
    self.level.is_relaunched_by_debug_runner = true
    self.add_child(self.level)
