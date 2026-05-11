@abstract class_name BaseLevel
extends Node2D


const debug_runner__path := "res://scenes/debug/DebugRunner.tscn"

const wancat__scene := preload("res://scenes/actors/WanCat/WanCat.tscn")


var wancat: WanCat = null

var is_relaunched_by_debug_runner: bool = false


## Override this for [method _ready].
@abstract func __onReady__() -> void;

## Called when WanCat character is ready.
## Access [member wancat] by [code]self.wancat[/code].
@abstract func __onWanCatReady__() -> void;


func _ready() -> void:
    if self.isRunningInDebugMode():
        if not self.is_relaunched_by_debug_runner:
            # Should redirect to debug runner.
            print(self.scene_file_path)
            self.launchAgainByDebugRunner()
            return

    self.__onReady__()

func isRunningInDebugMode() -> bool:
    if not OS.is_debug_build():
        return false

    if not self.is_relaunched_by_debug_runner:
        if get_tree().current_scene != self:
            return false

    return true

func launchAgainByDebugRunner():
    get_tree().set_meta("debug_runner__scene_to_launch__path", self.scene_file_path)
    get_tree().change_scene_to_file.bind(BaseLevel.debug_runner__path).call_deferred()

func spawnWanCat(
    spawn_global_position: Vector2,
    initial_facing_direction: Vector2 = Vector2.RIGHT
) -> WanCat:
    if self.wancat != null and is_instance_valid(self.wancat):
        return self.wancat

    self.wancat = BaseLevel.wancat__scene.instantiate() as WanCat

    self.add_child(self.wancat)

    self.wancat.global_position = spawn_global_position

    if initial_facing_direction != Vector2.ZERO:
        self.wancat.facing_direction = initial_facing_direction.normalized()

    self.__onWanCatReady__()

    return self.wancat
