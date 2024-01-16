from enum import Enum
from typing import TypedDict, Union

from .base import ObservableModel


class Color(Enum):
    BLACK = 0
    RED = 1
    GREEN = 2
    BLUE = 3

class Mode(Enum):
    VIEW = 0
    DRAW = 1

class PenState:
    size = 1
    color = Color.BLACK

class Editor(ObservableModel):
    def __init__(self):
        super().__init__()
        self.pen = PenState()
        self.mode = Mode.VIEW

    def toggle_mode(self) -> None:
        if self.mode == Mode.VIEW:
            self.mode = Mode.DRAW
        elif self.mode == Mode.DRAW:
            self.mode = Mode.VIEW

        self.trigger("editor::mode")

    def set_pen(self, pen: PenState) -> None:
        self.pen = pen
        self.trigger("editor::pen::set")
