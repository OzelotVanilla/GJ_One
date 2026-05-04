@abstract class_name BaseLevel
extends Node2D


const debug_runner__path := "res://scenes/debug/DebugRunner.tscn"


## Override this for [method _ready].
@abstract func __onReady__() -> void;

## Called when WanCat character is ready.
@abstract func __onWanCatReady__(player: Node) -> void;

func _ready() -> void:
    if self.shouldRedirectToDebugRunner():
        print(self.scene_file_path)
        self.launchAgainByDebugRunner()
        return

    self.__onReady__()

func shouldRedirectToDebugRunner() -> bool:
    if not OS.is_debug_build():
        return false

    if get_tree().current_scene != self:
        return false

    return true

func launchAgainByDebugRunner():
    get_tree().set_meta("debug_runner__scene_to_launch__path", self.scene_file_path)
    get_tree().change_scene_to_file.bind(BaseLevel.debug_runner__path).call_deferred()
