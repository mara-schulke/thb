from enum import Enum
from tkinter import filedialog
from typing import TypedDict, Union

import PIL as pillow

from .base import ObservableModel


class Effect(Enum):
    GRAYSCALE = 0
    BLUR = 1
    CONTOUR = 2
    DETAIL = 3
    EMBOSS = 4
    EDGE_ENHANCE = 5
    SHARPEN = 6
    SMOOTH = 7

class Canvas(ObservableModel):
    def __init__(self):
        super().__init__()
        self.width = 512
        self.height = 512
        self.scale = 1
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size(), color='white')]
        self.hidden = []
        self.trigger("canvas::update")

    def size(self) -> (int, int):
        return (self.width, self.height)

    def load(self, path: str) -> None:
        if not path:
            return

        self.file = path
        self.layers = [pillow.Image.open(self.file).convert('RGBA')]
        self.hidden = []
        self.width, self.height = self.layers[0].size
        self.trigger("canvas::open")
        self.trigger("canvas::render")

    def merged(self):
        merged = pillow.Image.new('RGBA', self.size(), (0, 0, 0, 0))

        for layer in self.layers:
            merged.paste(layer, (0, 0), layer)

        return merged

    def save(self, path: str) -> None:
        if not path:
            return

        self.merged().save(path)
        self.trigger("canvas::save")

    def reset(self) -> None:
        self.width = 512
        self.height = 512
        self.scale = 1
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size(), color="white")]
        self.hidden = []
        self.trigger("canvas::reset")
        self.trigger("canvas::render")

    # utils

    def set_scale(self, scale: int) -> None:
        self.scale = scale

    # layers

    def apply(self, effect) -> None:
        layer = self.layers[-1]

        if effect == Effect.GRAYSCALE:
            self.layers[-1] = pillow.ImageOps.grayscale(layer)
        elif effect == Effect.BLUR:
            self.layers[-1] = layer.filter(pillow.ImageFilter.BLUR)
        elif effect == Effect.CONTOUR:
            self.layers[-1] = layer.filter(pillow.ImageFilter.CONTOUR)
        elif effect == Effect.DETAIL:
            self.layers[-1] = layer.filter(pillow.ImageFilter.DETAIL)
        elif effect == Effect.EMBOSS:
            self.layers[-1] = layer.filter(pillow.ImageFilter.EMBOSS)
        elif effect == Effect.EDGE_ENHANCE:
            self.layers[-1] = layer.filter(pillow.ImageFilter.EDGE_ENHANCE)
        elif effect == Effect.SHARPEN:
            self.layers[-1] = layer.filter(pillow.ImageFilter.SHARPEN)
        elif effect == Effect.SMOOTH:
            self.layers[-1] = layer.filter(pillow.ImageFilter.SMOOTH)

        self.trigger("canvas::render")

    def new_layer(self) -> None:
        self.layers.append(pillow.Image.new(mode='RGBA', size=self.size()))
        self.trigger("canvas::render")

    def del_layer(self) -> None:
        if len(self.layers) > 1:
            self.layers.pop()

        self.trigger("canvas::render")
