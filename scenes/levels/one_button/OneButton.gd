extends BaseLevel


@onready var button: BarkToChangeButton = $Button


var is_wancat_appeared: bool = false


func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


func startGame():
    if self.isRunningInDebugMode():
        print("Start")

func connectButtonPressToStart():
    self.clearButtonPressedConnections()
    self.button.pressed.connect(self.startGame)
    self.button.text = "START"

func quitGame():
    get_tree().quit(22)

func connectButtonPressToQuit():
    self.clearButtonPressedConnections()
    self.button.pressed.connect(self.quitGame)
    self.button.text = "QUIT"

func clearButtonPressedConnections():
    for c in self.button.pressed.get_connections():
        self.button.pressed.disconnect(c["callable"])

func on_Button_bark_received(bark: BarkWave):
    match bark.ability:
        "QUIT":
            self.connectButtonPressToQuit()

        "START":
            self.connectButtonPressToStart()

func __onReady__() -> void:
    self.connectButtonPressToQuit()

func __onWanCatReady__() -> void:
    self.wancat.bark_ability_list = [
        "QUIT",
        "START"
    ]

    self.wancat.current_bark_ability_index = 0
    self.wancat.applyAbilityIndexChange()

func __onUnhandledInput__(event: InputEvent):
    if not self.is_wancat_appeared:
        if event.is_action_pressed("move_left"):
            self.spawnWanCatFromScreenSide(Vector2.RIGHT)
            self.is_wancat_appeared = true
        if event.is_action_pressed("move_right"):
            self.spawnWanCatFromScreenSide(Vector2.LEFT)
            self.is_wancat_appeared = true
        if event.is_action_pressed("move_up"):
            self.spawnWanCatFromScreenSide(Vector2.DOWN)
            self.is_wancat_appeared = true
        if event.is_action_pressed("move_down"):
            self.spawnWanCatFromScreenSide(Vector2.UP)
            self.is_wancat_appeared = true

func spawnWanCatFromScreenSide(side_direction: Vector2):
    var viewport_size := get_viewport_rect().size
    var margin := 48.0

    var spawn_position := viewport_size * 0.5
    var facing_direction := -side_direction

    if side_direction == Vector2.LEFT:
        spawn_position = Vector2(-margin, viewport_size.y * 0.5)
    elif side_direction == Vector2.RIGHT:
        spawn_position = Vector2(viewport_size.x + margin, viewport_size.y * 0.5)
    elif side_direction == Vector2.UP:
        spawn_position = Vector2(viewport_size.x * 0.5, -margin)
    elif side_direction == Vector2.DOWN:
        spawn_position = Vector2(viewport_size.x * 0.5, viewport_size.y + margin)

    self.spawnWanCat(spawn_position, facing_direction)
