class_name MirrorReflectionArea
extends Area2D


var mirror__ref: Mirror

func on_BarkWave_received(bark_wave: BarkWave):
    self.mirror__ref.on_ReflectionArea_BarkWave_received(bark_wave)
