from typing import TypedDict, Union

from .base import ObservableModel


class Image(ObservableModel):
    def __init__(self):
        super().__init__()
        self.path = ""

    def load(self, path: str) -> None:
        self.path = path
        self.trigger("image::load")

    def logout(self) -> None:
        self.path = ""
        self.trigger("image::unload")
