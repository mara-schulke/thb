from enum import Enum
from typing import TypedDict, Union

from .base import ObservableModel


class Color(Enum):
    """
    An enumeration of basic colors with a method to return the corresponding Tkinter color string.
    """

    BLACK = 0
    RED = 1
    GREEN = 2
    BLUE = 3

    def as_tk_color(self) -> str:
        """
        Converts the enum member to its corresponding Tkinter color string.

        Returns:
            str: The Tkinter string representation of the color.
        """

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
    """
    An enumeration representing the different modes of operation in the editor.
    """

    VIEW = 0
    DRAW = 1
    ERASE = 2

class PenState:
    """
    Represents the state of the pen tool, including size, color, and tracking of last points and usage.
    """

    size = 10
    color = Color.BLACK

    last_points = []
    last_usage = None


class Editor(ObservableModel):
    """
    Represents the editor state, including the current pen and mode.

    Inherits from ObservableModel to enable event-driven communication with other components.
    """

    def __init__(self):
        """
        Initializes the Editor with default pen settings and in VIEW mode.
        """
        super().__init__()
        self.pen = PenState()
        self.mode = Mode.VIEW

    def toggle_pen(self) -> None:
        """
        Toggles the editor mode between DRAW and VIEW, updating the mode accordingly.
        """

        if self.mode == Mode.VIEW or self.mode == Mode.ERASE:
            self.mode = Mode.DRAW
        elif self.mode == Mode.DRAW:
            self.mode = Mode.VIEW

        self.trigger("editor::mode")

    def toggle_erasor(self) -> None:
        """
        Toggles the editor mode between ERASE and VIEW, updating the mode accordingly.
        """

        if self.mode == Mode.VIEW or self.mode == Mode.DRAW:
            self.mode = Mode.ERASE
        elif self.mode == Mode.ERASE:
            self.mode = Mode.VIEW

        self.trigger("editor::mode")

    def set_pen(self, pen: PenState) -> None:
        """
        Sets the current pen state to the provided PenState object.

        Parameters:
            pen (PenState): The new state to set for the pen.
        """

        self.pen = pen
        self.trigger("editor::pen::set")
