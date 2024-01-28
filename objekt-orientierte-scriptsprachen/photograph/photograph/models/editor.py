from enum import Enum
from typing import TypedDict, Union

from .base import ObservableModel


class Color(Enum):
    BLACK = 0
    RED = 1
    GREEN = 2
    BLUE = 3

    def as_tk_color(self) -> str:
        if self == Color.BLACK:
            return "black"
        elif self == Color.RED:
            return "red"
        elif self == Color.Green:
            return "green"
        elif self == Color.BLUE:
            return "blue"
        else:
            return "black"

class Mode(Enum):
    VIEW = 0
    DRAW = 1
    ERASE = 2

class PenState:
    size = 10
    color = Color.BLACK

    last_points = []
    last_usage = None


class Editor(ObservableModel):
    def __init__(self):
        super().__init__()
        self.pen = PenState()
        self.mode = Mode.VIEW

    def toggle_pen(self) -> None:
        if self.mode == Mode.VIEW or self.mode == Mode.ERASE:
            self.mode = Mode.DRAW
        elif self.mode == Mode.DRAW:
            self.mode = Mode.VIEW

        self.trigger("editor::mode")

    def toggle_erasor(self) -> None:
        if self.mode == Mode.VIEW or self.mode == Mode.DRAW:
            self.mode = Mode.ERASE
        elif self.mode == Mode.ERASE:
            self.mode = Mode.VIEW

        self.trigger("editor::mode")

    def set_pen(self, pen: PenState) -> None:
        self.pen = pen
        self.trigger("editor::pen::set")
