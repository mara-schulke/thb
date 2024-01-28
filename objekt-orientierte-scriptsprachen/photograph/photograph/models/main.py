from .canvas import Canvas
from .editor import Editor


class Model:
    """
    Represents the central model in the application, encapsulating the state and functionality
    of both the editor and the canvas components.

    This class serves as the main data model for the application, holding instances of the `Editor`
    and `Canvas` classes. It acts as a container that allows other parts of the application to
    interact with the editor and canvas functionalities.

    Attributes:
        editor (Editor): An instance of the `Editor` class, representing the state and functionality
            of the image editing tools and modes.
        canvas (Canvas): An instance of the `Canvas` class, representing the drawable area, including
            its layers and the ability to apply various image effects.
    """

    def __init__(self):
        """
        Initializes the `Model` with new instances of `Editor` and `Canvas`.
        """

        self.editor = Editor()
        self.canvas = Canvas()
