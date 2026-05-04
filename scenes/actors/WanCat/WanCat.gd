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


func _physics_process(delta: float) -> void: self.__onPhysicsProcess__(delta)
func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


func bark():
    var now := Time.get_ticks_msec() / 1000.0
    if now - self.last_bark__timestamp < self.bark_cooldown_secs:
        # Still cooling down.
        return

    self.last_bark__timestamp = now

    # # Spawn a bark wave.
    var bark_wave: BarkWave = WanCat.bark_wave__scene.instantiate()
    bark_wave.global_position = \
        self.global_position + self.facing_direction * self.bark_offset
    bark_wave.rotation = self.facing_direction.angle()

    self.get_parent().add_child(bark_wave)

    # # Add effectext.
    var effectext: WanText = self.wan_text__scene.instantiate()
    effectext.global_position = self.global_position + Vector2(0, -50 * self.scale.x)

    self.get_parent().add_child(effectext)

func __onPhysicsProcess__(delta: float):
    var new_move_vector := \
        Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if new_move_vector != Vector2.ZERO:
        self.facing_direction = new_move_vector.normalized()

    # # Move character.
    self.velocity = new_move_vector * self.speed
    self.move_and_slide()

    # # Test if bark.
    if Input.is_action_just_pressed("bark"):
        self.bark()

func __onUnhandledInput__(event: InputEvent):
    if event.is_action_pressed("bark"):
        self.bark()
