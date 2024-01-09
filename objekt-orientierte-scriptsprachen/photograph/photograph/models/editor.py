from enum import Enum
from typing import TypedDict, Union

from .base import ObservableModel


class Color(Enum):
    BLACK = 0
    RED = 1
    GREEN = 2
    BLUE = 3

class PenState:
    size = 1
    color = Color.BLACK

class Editor(ObservableModel):
    def __init__(self):
        super().__init__()
        self.pen = PenState()

    def set_pen(self, pen: PenState) -> None:
        self.pen = pen
        self.trigger("editor::pen::set")
