from tkinter import filedialog
from typing import TypedDict, Union

import PIL as pillow

from .base import ObservableModel


class Canvas(ObservableModel):
    def __init__(self):
        super().__init__()
        self.width = 512
        self.height = 512
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size())]
        self.hidden = []
        self.active = 0
        self.trigger("canvas::update")

    def size(self) -> (int, int):
        return (self.width, self.height)

    def load(self, path: str) -> None:
        if not path:
            return

        self.file = path
        self.layers = [pillow.Image.open(self.file)]
        self.hidden = []
        self.width = self.layers[0].width
        self.height = self.layers[0].height
        self.active = 0
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
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size())]
        self.hidden = []
        self.active = 0
        self.trigger("canvas::reset")
        self.trigger("canvas::render")

    # layers

    def activate(self, n) -> None:
        if n < len(self.layers) and n >= 0:
            print("activate", n)
            self.active = n
            self.trigger("canvas::render")

    def new_layer(self) -> None:
        self.layers.append(pillow.Image.new(mode='RGBA', size=self.size()))
        self.active = len(self.layers) - 1
        self.trigger("canvas::render")

    def rm_layer(self, i) -> None:
        if i == 0:
            print("cant delete layer 0")

        del self.layers[i]

        if i == self.active:
            self.active = 0

        self.trigger("canvas::render")
