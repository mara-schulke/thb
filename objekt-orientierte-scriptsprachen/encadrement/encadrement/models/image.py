from tkinter import filedialog
from typing import TypedDict, Union

import PIL as pillow

from .base import ObservableModel


class Image(ObservableModel):
    def __init__(self):
        super().__init__()

        self.source = ""
        self.image = pillow.Image.new(mode="RGBA", size=(512,512))

    def load(self, path: str) -> None:
        if not path:
            return

        self.source = path
        self.image = pillow.Image.open(self.source)

        print("image loaded")
        self.trigger("image::load")

    def save(self, path: str) -> None:
        if not path:
            return

        self.image.save(path)
        self.trigger("image::save")

    def reset(self) -> None:
        self.source = ""
        self.trigger("image::unload")
