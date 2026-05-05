@tool
class_name WanCat
extends CharacterBody2D


const bark_wave__scene := preload("res://scenes/effects/BarkWave/BarkWave.tscn")

const wan_text__scene := preload("res://scenes/actors/WanCat/WanText.tscn")


@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:px/s")
var init_speed: float = 600.0

@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:s")
var bark_cooldown_secs: float = 0.2

@export_custom(PropertyHint.PROPERTY_HINT_NONE, "suffix:px")
var bark_offset: int = 20


var speed: float = self.init_speed

var facing_direction: Vector2 = Vector2.ZERO

var last_bark__timestamp := -self.bark_cooldown_secs

## Contains ability that could be emit when barking.
var bark_ability_list: Array[String] = ["NONE", "EMPTY"]

var current_bark_ability_index := 0:
    set(new_index):
        var arr_len := self.bark_ability_list.size()
        current_bark_ability_index = (new_index % arr_len + arr_len) % arr_len
        self.applyAbilityIndexChange()

var current_selected_ability: String:
    get():
        return self.bark_ability_list[self.current_bark_ability_index]


@onready var sprite: Sprite2D = $Sprite2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var bark_ability_label: Label = $BarkAbilityLabel


func _physics_process(delta: float) -> void: self.__onPhysicsProcess__(delta)
func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)
func _ready() -> void: self.__onReady__()


func bark():
    var now := Time.get_ticks_msec() / 1000.0
    if now - self.last_bark__timestamp < self.bark_cooldown_secs:
        # Still cooling down.
        return

    self.last_bark__timestamp = now

    # # Spawn a bark wave.
    var bark_wave: BarkWave = WanCat.bark_wave__scene.instantiate()
    self.get_parent().add_child(bark_wave)
    bark_wave.global_position = \
        self.global_position + self.facing_direction * self.bark_offset
    bark_wave.rotation = self.facing_direction.angle()
    bark_wave.ability  = self.current_selected_ability

    # # Add effectext.
    var effectext: WanText = self.wan_text__scene.instantiate()
    self.get_parent().add_child(effectext)
    effectext.global_position = self.global_position + Vector2(0, -50 * self.scale.x)

## Sync the size of sprite to other components.
func syncSize():
    var size := self.sprite.get_rect().size * self.sprite.scale.abs()

    self.collision_shape.scale = Vector2.ONE

    var collision_rect := self.collision_shape.shape as RectangleShape2D
    if collision_rect != null:
        collision_rect.size = size

    self.bark_ability_label.position = -size / 2.0
    self.bark_ability_label.size = size

    self.queue_redraw()

func applyAbilityIndexChange():
    if not self.is_node_ready():
        return

    self.bark_ability_label.text = self.current_selected_ability

    self.queue_redraw()

func __onPhysicsProcess__(delta: float):
    if Engine.is_editor_hint():
        return

    var new_move_vector := \
        Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if new_move_vector != Vector2.ZERO:
        self.facing_direction = new_move_vector.normalized()

    # # Move character.
    self.velocity = new_move_vector * self.speed
    self.move_and_slide()

func __onUnhandledInput__(event: InputEvent):
    if Engine.is_editor_hint():
        return

    if event.is_action_pressed("bark"):
        self.bark()

    if event.is_action_pressed("ability_prev"):
        self.current_bark_ability_index -= 1
    if event.is_action_pressed("ability_next"):
        self.current_bark_ability_index += 1

func __onReady__():
    if Engine.is_editor_hint():
        self.set_process(false)
        self.set_physics_process(false)

    self.applyAbilityIndexChange()
    self.syncSize()
