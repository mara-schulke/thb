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
        self.active = 0

    def size(self) -> (int, int):
        return (self.width, self.height)

    def load(self, path: str) -> None:
        if not path:
            return

        self.file = path
        self.layers = [pillow.Image.open(self.file)]
        self.width = self.layers[0].width
        self.height = self.layers[0].height
        self.active = 0
        self.trigger("canvas::open")

    def merged(self):
        return pillow.Image.merge(mode='RGBA', bands=self.layers)

    def save(self, path: str) -> None:
        if not path:
            return

        self.merged().save(path)
        self.trigger("image::save")

    def reset(self) -> None:
        self.width = 512
        self.height = 512
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size())]
        self.active = 0
        self.trigger("canvas::reset")
